import 'package:flutter/material.dart';
import 'expense_Object.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker team 3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExpenseScreen(),
    );
  }
}

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final List<Expense> _expenses = [];

  void _addExpense(String title, double amount) {
    setState(() {
      _expenses
          .add(Expense(title: title, amount: amount, date: DateTime.now()));
    });
  }

  void _removeExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  void _showAddExpenseDialogue() {
    showDialog(
      context: context,
      builder: (context) => AddExpenseDialogue(onAddExpense: _addExpense),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 31, 207),
        title: const Text("Today's Expenses"),
      ),
      body: ListView.builder(
        itemCount: _expenses.length,
        itemBuilder: (context, index) {
          final expense = _expenses[index];
          return ListTile(
            title: Text(expense.title),
            subtitle: Text("\$${expense.amount.toStringAsFixed(2)}"),
            trailing: IconButton(
              onPressed: () => _removeExpense(index),
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialogue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddExpenseDialogue extends StatefulWidget {
  final Function(String, double) onAddExpense;
  AddExpenseDialogue({super.key, required this.onAddExpense});

  @override
  State<AddExpenseDialogue> createState() => _AddExpenseDialogueState();
}

class _AddExpenseDialogueState extends State<AddExpenseDialogue> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  void _submitExpense() {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text);
    if (title.isEmpty || amount == null || amount <= 0) return;
    widget.onAddExpense(title, amount);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Expense'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Expense'),
          ),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _submitExpense,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
