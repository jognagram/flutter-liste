import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestion de tache',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  //Nous avons deux listes pour stocker les taches : _todoList, _completeList
  final List<String> _todoList = [];
  final List<String> _completedList = [];

  //Les méthodes '_addToDoList' et _markAsCompleted' seront utilisé pour ajouter des tâches respectivements
  void _addToTodoList(String task) {
    setState(() {
      _todoList.add(task);
    });
  }

  void _markAsCompleted(int index) {
    setState(() {
      _completedList.add(_todoList[index]);
      _todoList.removeAt(index);
    });
  }

  @override
  //La méthode build crée une interface utilisateur avec un 'DefaultTabController' et un 'TabBarView'. Le TabBarViex a deux onglets, l'un pour les taches en cours et l'autre pour les taches terminées
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Gestion de tache'),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.list), text: 'To-Do List'),
                Tab(icon: Icon(Icons.done), text: 'Completed Tasks'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildTodoListTab(),
              _buildCompletedTasksTab(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddTaskDialog(context),
            tooltip: 'Add Task',
            child: const Icon(Icons.add),
          ),
        ));
  }

  @override
//Les methodes '_buildTodoListTab et buildCompletedTab créent des 'ListView.builder pour afficher les tâches en cours et les tâches terminées, respectivement
  Widget _buildTodoListTab() {
    return ListView.builder(
      itemCount: _todoList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_todoList[index]),
          trailing: IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _markAsCompleted(index),
          ),
        );
      },
    );
  }

  Widget _buildCompletedTasksTab() {
    return ListView.builder(
      itemCount: _completedList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_completedList[index]),
          leading: const Icon(
            Icons.done,
            color: Colors.green,
          ),
        );
      },
    );
  }

  //La méthode _showAddTaskDialog affiche une boite de dialog permettant d'ajouter une nouvelle tache a la liste des taches
  void _showAddTaskDialog(BuildContext context) {
    // Créez un TextEditingController local là méthode pour éviter les fuites de memoires
    TextEditingController taskController = TextEditingController();

    //Fonction pour nettoyer le TextEditing controler après une utilisation
    void _clearController() {
      taskController.dispose();
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a new task'),
            content: TextField(
              controller: taskController,
              decoration: InputDecoration(hintText: 'Enter task name'),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _clearController();
                },
              ),
              TextButton(
                child: const Text('Add'),
                onPressed: () {
                  _addToTodoList(taskController.text);
                  Navigator.of(context).pop();
                  _clearController();
                },
              ),
            ],
          );
        });
  }
}
