import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddClassDialog extends StatefulWidget {
  const AddClassDialog({super.key});

  @override
  State<AddClassDialog> createState() => _AddClassDialogState();
}

class _AddClassDialogState extends State<AddClassDialog> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isLoading = false;

  Future<void> _addNewClass() async {
    if (_nameController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _imageUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Insert to Supabase
      await Supabase.instance.client.from('classes').insert({
        'name': _nameController.text,
        'location': _locationController.text,
        'image_url': _imageUrlController.text,
      });

      _nameController.clear();
      _locationController.clear();
      _imageUrlController.clear();

      if (!mounted) return;
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Class added successfully!')),
      );
      
      // Close dialog and go back to home screen
      Navigator.pop(context);
      
    } catch (e) {
      print('Error adding class: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Class'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Class Name',
                border: OutlineInputBorder(),
                hintText: 'e.g., Mathematics',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                hintText: 'e.g., Dera Ghazi Khan',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(),
                hintText: 'e.g., https://images.unsplash.com/...',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _nameController.clear();
            _locationController.clear();
            _imageUrlController.clear();
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _addNewClass,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add Class'),
        ),
      ],
    );
  }
}


