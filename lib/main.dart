import 'package:flutter/material.dart';

import 'package:testform/model.dart';
import 'package:testform/repository.dart';

void main(List<String> args) {
  runApp(const MaterialApp(
    home: FamilyMembersList(),
  ));
}

class FamilyMembersList extends StatefulWidget {
  const FamilyMembersList({super.key});

  @override
  State<FamilyMembersList> createState() => _FamilyMembersListState();
}

class _FamilyMembersListState extends State<FamilyMembersList> {
  final List<FamilyMember> _familyMembers = [];
  final List<GlobalKey<FormState>> _formKeys = [];
  final ScrollController _scrollController = ScrollController();
  final FamilyMemberService _service = FamilyMemberService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addFirstMember();
  }

  void _addFirstMember() {
    final firstMember = FamilyMember();
    firstMember.name = 'hruaia';

    setState(() {
      _familyMembers.add(firstMember);
      _formKeys.add(GlobalKey<FormState>());
    });
  }

  void _addMember() {
    setState(() {
      _familyMembers.add(FamilyMember());
      _formKeys.add(GlobalKey<FormState>());
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _removeMember(int index) {
    setState(() {
      _familyMembers.removeAt(index);
      _formKeys.removeAt(index);
    });
  }

  Future<void> _submitFamilyMembers() async {
    bool isValid = true;
    for (var formKey in _formKeys) {
      if (!(formKey.currentState?.validate() ?? false)) {
        isValid = false;
      }
    }

    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _service.submitFamilyMembers(_familyMembers);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Family members submitted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error submitting family members: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Members'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _familyMembers.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKeys[index], // Assign the form key to each Form
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Member ${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            initialValue: _familyMembers[index].name,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _familyMembers[index].name = value;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: TextEditingController(
                              text: _familyMembers[index].dob != null
                                  ? '${_familyMembers[index].dob!.day}/${_familyMembers[index].dob!.month}/${_familyMembers[index].dob!.year}'
                                  : '',
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Date of Birth',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate:
                                    _familyMembers[index].dob ?? DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setState(() {
                                  _familyMembers[index].dob = date;
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a date of birth';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _familyMembers[index].gender,
                            decoration: const InputDecoration(
                              labelText: 'Gender',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                            hint: const Text('Select Gender'),
                            items: const [
                              DropdownMenuItem(
                                value: 'male',
                                child: Text('Male'),
                              ),
                              DropdownMenuItem(
                                value: 'female',
                                child: Text('Female'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _familyMembers[index].gender = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a gender';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CheckboxListTile(
                            title: const Text('Is Indian'),
                            value: _familyMembers[index].isIndian,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (bool? value) {
                              setState(() {
                                _familyMembers[index].isIndian = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _addMember,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Family Member'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 8), // Add some spacing between buttons
                    ElevatedButton(
                      onPressed: _familyMembers.isEmpty
                          ? null
                          : () => _removeMember(_familyMembers.length - 1),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(48, 48),
                        backgroundColor:
                            Colors.red, // Red color for the delete button
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                if (_familyMembers.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitFamilyMembers,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Submit'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
