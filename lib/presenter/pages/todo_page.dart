import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presenter/cubits/activity_cubit/activity_state.dart';
import '../cubits/activity_cubit/activity_cubit.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late final TodoCubit cubit;

  final TextEditingController titleController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  bool isVisible = true;
  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<TodoCubit>(context);
    // cubit = context.read<TodoCubit>();

    scrollController.addListener(onScroll);
  }

  onScroll() {
    setState(() {
      isVisible = scrollController.position.userScrollDirection ==
          ScrollDirection.forward;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Todo Cubit"),
        ),
        body: Stack(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: TodoList(cubit, () {
              setState(() {
                if (!isKeyboardVisible) {
                  isVisible = !isVisible;
                }
              });
            }, scrollController),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: isVisible ? 80 : 0,
                curve: Curves.easeInOut,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, -5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              labelText: "Tarefa",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    width: 4.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeInOut,
                          opacity: isVisible ? 1 : 0,
                          child: IconButton(
                            icon: const Icon(Icons.add),
                            color: Colors.white,
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                              Colors.grey,
                            )),
                            onPressed: () {
                              if (titleController.text.isNotEmpty) {
                                cubit.addActivity(titleController.text);
                                titleController.clear();
                              }
                            },
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ]));
  }
}

class TodoList extends StatefulWidget {
  final TodoCubit cubit;
  final VoidCallback callback;
  final ScrollController controller;
  const TodoList(this.cubit, this.callback, this.controller, {super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, ActivityState>(
        bloc: widget.cubit,
        builder: (context, state) {
          if (state is ActivityInitialState) {
            widget.cubit.showInit();
            if (state.activities == null) {
              return Center(
                child: Text(state.mensagem),
              );
            } else {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                controller: widget.controller,
                shrinkWrap: true,
                itemCount: state.activities!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      widget.callback();
                    },
                    title: Text(state.activities![index].activity),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          state.activities![index].activity[0].toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        widget.cubit
                            .removeActivity(state.activities![index].id);
                      },
                    ),
                  );
                },
              );
            }
          } else if (state is ActivityLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ActivityLoadedState) {
            return state.activities.isEmpty
                ? const Center(
                    child: Text("Nenhuma atividade registrada"),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const ScrollPhysics(),
                    controller: widget.controller,
                    shrinkWrap: true,
                    itemCount: state.activities.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          widget.callback();
                        },
                        title: Text(state.activities[index].activity),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Text(
                              state.activities[index].activity[0].toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            widget.cubit
                                .removeActivity(state.activities[index].id);
                          },
                        ),
                      );
                    },
                  );
          } else if (state is ActivityErrorState) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: Text("Adicione uma tarefa"),
            );
          }
        });
  }
}
