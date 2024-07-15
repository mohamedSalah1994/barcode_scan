import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'all_saved_data_screen.dart';
import 'barcode_screen.dart';
import 'components/home_textfield.dart';
import 'components/my_button.dart';
import 'models/barcode_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = 'homeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  int _selectedCategoryId = 0; // Default category ID
  int _selectedSubCategoryId = 0; // Default sub category ID
  int _selectedNetworkId = 0; // Default network type ID
  String _selectedRow = '';
  String _selectedContainment = '';
  String _selectedRack = '';
  String _partNumber = '';
  String _model = '';
  String _vendor = '';
  String _description = '';
  DateTime? _startDate;
  DateTime? _endDate;
  String _powerConsumption = '';
  String _comment = '';

  final Map<int, String> _categories = {
    1: 'Network',
    2: 'Server',
    3: 'Storage',
  };

  final Map<int, String> _subCategories = {
    1: 'a',
    2: 'b',
    3: 'c',
  };

  final Map<int, String> _networkTypes = {
    1: 'M',
    2: 'P',
    3: 'G',
  };

  Future<void> _selectDate(BuildContext context, DateTime? initialDate,
      Function(DateTime?) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != initialDate) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
        actions: [
        IconButton(onPressed: () async{
          await _clearAllSavedData(context);
        }, icon: const Icon(Icons.delete , color: Colors.red, size: 32,))
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: autovalidateMode,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                _buildHeader('Row'),
                HomeTextField(
                  text: 'Row',
                  onChanged: (value) {
                    setState(() {
                      _selectedRow = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildHeader('Containment'),
                HomeTextField(
                  text: 'Containment',
                  onChanged: (value) {
                    setState(() {
                      _selectedContainment = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildHeader('Rack'),
                HomeTextField(
                  text: 'Rack',
                  onChanged: (value) {
                    setState(() {
                      _selectedRack = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildHeader('Main Category'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: FormField<String>(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a main category';
                      }
                      return null;
                    },
                    builder: (FormFieldState<String> state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            value: _categories[_selectedCategoryId],
                            decoration: const InputDecoration(
                              labelText: 'Select Main Category',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCategoryId = _categories.entries
                                    .firstWhere((entry) => entry.value == newValue)
                                    .key;
                              });
                              state.didChange(newValue);
                            },
                            items: _categories.entries.map((entry) {
                              return DropdownMenuItem<String>(
                                value: entry.value,
                                child: Text(entry.value),
                              );
                            }).toList(),
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                state.errorText ?? '',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _buildHeader('Sub Category'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: FormField<String>(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a sub category';
                      }
                      return null;
                    },
                    builder: (FormFieldState<String> state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            value: _subCategories[_selectedSubCategoryId],
                            decoration: const InputDecoration(
                              labelText: 'Select Sub Category',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedSubCategoryId = _subCategories.entries
                                    .firstWhere((entry) => entry.value == newValue)
                                    .key;
                              });
                              state.didChange(newValue);
                            },
                            items: _subCategories.entries.map((entry) {
                              return DropdownMenuItem<String>(
                                value: entry.value,
                                child: Text(entry.value),
                              );
                            }).toList(),
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                state.errorText ?? '',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _buildHeader('Network Type'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: FormField<String>(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a network type';
                      }
                      return null;
                    },
                    builder: (FormFieldState<String> state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            value: _networkTypes[_selectedNetworkId],
                            decoration: const InputDecoration(
                              labelText: 'Select Network Type',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedNetworkId = _networkTypes.entries
                                    .firstWhere((entry) => entry.value == newValue)
                                    .key;
                              });
                              state.didChange(newValue);
                            },
                            items: _networkTypes.entries.map((entry) {
                              return DropdownMenuItem<String>(
                                value: entry.value,
                                child: Text(entry.value),
                              );
                            }).toList(),
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                state.errorText ?? '',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _buildHeader('Part Number'),
                HomeTextField(
                  text: 'Part Number',
                  onChanged: (value) {
                    setState(() {
                      _partNumber = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildHeader('Model'),
                HomeTextField(
                  text: 'Model',
                  onChanged: (value) {
                    setState(() {
                      _model = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildHeader('Vendor'),
                HomeTextField(
                  text: 'Vendor',
                  onChanged: (value) {
                    setState(() {
                      _vendor = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildHeader('Description'),
                HomeTextField(
                  text: 'Description',
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildHeader('Power Consumption'),
                HomeTextField(
                  text: 'Power Consumption',
                  onChanged: (value) {
                    setState(() {
                      _powerConsumption = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildHeader('Start Date'),
                _buildDateFieldWithValidation(
                  context,
                  _startDate,
                  'Select Start Date',
                  (date) {
                    setState(() {
                      _startDate = date;
                    });
                  },
                  'Please select a start date',
                ),
                const SizedBox(height: 20),
                _buildHeader('End Date'),
                _buildDateFieldWithValidation(
                  context,
                  _endDate,
                  'Select End Date',
                  (date) {
                    setState(() {
                      _endDate = date;
                    });
                  },
                  'Please select an end date',
                  startDate: _startDate,
                ),
                const SizedBox(height: 20),
                _buildHeader('Comment'),
                HomeTextField(
                  text: 'Comment',
                  onChanged: (value) {
                    setState(() {
                      _comment = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                MyButton(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRViewExample(
                            selectedCategory: _categories[_selectedCategoryId]!,
                            selectedNetworkType: _networkTypes[_selectedNetworkId]!,
                            containment: _selectedContainment,
                            rack: _selectedRack,
                            row: _selectedRow,
                            partNumber: _partNumber,
                            model: _model,
                            vendor: _vendor,
                            description: _description,
                            startDate: _startDate,
                            endDate: _endDate,
                            powerConsumption: _powerConsumption,
                            comment: _comment,
                            selectedSubCategory: _subCategories[_selectedSubCategoryId]!,
                          ),
                        ),
                      );
                    } else {
                      setState(() {
                        autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                  title: 'Start Scanning',
                ),
                const SizedBox(height: 20),
                MyButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllSavedDataScreen(),
                      ),
                    );
                  },
                  title: 'Show All Saved Data',
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0 , vertical: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDateFieldWithValidation(
  BuildContext context,
  DateTime? date,
  String hintText,
  Function(DateTime?) onDateSelected,
  String validationMessage, {
  DateTime? startDate,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: FormField<DateTime>(
      validator: (value) {
        if (value == null) {
          return validationMessage;
        }
        if (startDate != null && value.isBefore(startDate)) {
          return 'End date cannot be before start date';
        }
        return null;
      },
      builder: (FormFieldState<DateTime> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _selectDate(context, date, (selectedDate) {
                onDateSelected(selectedDate);
                state.didChange(selectedDate);
              }),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: '',
                  border: const OutlineInputBorder(),
                  errorText: state.errorText,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date == null ? hintText : DateFormat('yyyy-MM-dd').format(date),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}

}

Future<void> _clearAllSavedData(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirm"),
        content: const Text("Are you sure you want to clear all data?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final box = await Hive.openBox<BarcodeModel>('barcodes');
              await box.clear();
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data cleared successfully.'),
                ),
              );
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            child: const Text("Clear"),
          ),
        ],
      );
    },
  );
}
