// import 'package:flutter/material.dart';
// import 'package:resumee/Custom_widget/Custom_text_field.dart';
// import 'package:resumee/data/data.dart';
// import 'package:resumee/resume_pdf.dart';

// class MultiStepForm extends StatefulWidget {
//   const MultiStepForm({super.key});

//   @override
//   State<MultiStepForm> createState() => _MultiStepFormState();
// }

// class _MultiStepFormState extends State<MultiStepForm> {
//   int _currentStep = 0;

//   final _formKeys = List.generate(4, (_) => GlobalKey<FormState>());
//   final List<bool> _completeSteps = [false, false, false, false];

//   String name = "";
//   String jobTitle = "";
//   String address = "";
//   DateTime? dateOfBirth;
//   String? gender;
//   String educationLevel = "";

//   List<Map<String, String>> workExperience = [];
//   List<Map<String, String>> educationList = [];
//   List<Map<String, dynamic>> skills = [];

//   String tempJobTitle = "";
//   String tempCompany = "";
//   String tempJobDescription = "";

//   String tempDegree = "";
//   String tempInstitution = "";
//   String tempEducationDescription = "";
//   String tempEducationLevel = "";

//   String tempSkill = "";
//   List<String> selectInterset = [];
//   double tempProficiency = 0.5;

//   void _onStepContinue() {
//     final isValid = _formKeys[_currentStep].currentState?.validate() ?? false;

//     if (isValid) {
//       _formKeys[_currentStep].currentState?.save();

//       if (_currentStep == 1) {
//         workExperience.add({
//           "jobTitle": tempJobTitle,
//           "company": tempCompany,
//           "description": tempJobDescription,
//         });
//       } else if (_currentStep == 2) {
//         educationList.add({
//           "degree": tempDegree,
//           "institution": tempInstitution,
//           "description": tempEducationDescription,
//           "educationLevel": tempEducationLevel,
//         });
//       } else if (_currentStep == 3) {
//         skills.add({"skill": tempSkill, "proficiency": tempProficiency});
//       }

//       if (_currentStep < _formKeys.length - 1) {
//         setState(() {
//           _completeSteps[_currentStep] = true;
//           _currentStep++;
//         });
//       }
//     }
//   }

//   Future<void> _generateResumePdf() async {
//     setState(() {
//       _isGenerating = true;
      
//     });
//     try{
//       final myFile=await generateResume(PdfPageFormat.letter,format, name: name, 
//       email: email,
//        jobTitle: jobTitle,
//         address: address,
//          phone: phone, 
//          website: website, 
//          profileImagePath: profileImagePath,
//           workExperience: workExperience, 
//           educationList: educationList, 
//           skills: skills, dateOfBirth: dateOfBirth !=null 
//           ? "${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}"
//           : "Not Provided",
//           , gender: gender, interests: interests),

// ScaffoldMessenger.of(context).showSnackBar{
//   SnackBar(content: backgroundColor:Colors.green,behavior: SnackBarBehavior.floating,
//   content:Text("PdF Generated SuccessFully ",style:TextStyle(color:Colors.white))
//   );
//   await OpenFile.open(myFile.path);
// }
//     }

//     catch(e){
//       print(e);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(behavior: SnackBarBehavior.floating, backgroundColor: Colors.red ,content: Text("Pdf Not Generated",style: TextStyle(color: Colors.white),))
//       );


//     }
//     finally{
//       setState(() {
//         _isGenerating=false;
//       });
//     }
//   }

//   void _onStepCancel() {
//     if (_currentStep > 0) {
//       setState(() => _currentStep--);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Stack(
//             alignment: Alignment.center,
//             clipBehavior: Clip.none,
//             children: [
//               Container(
//                 height: 140,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.vertical(
//                     bottom: Radius.circular(65),
//                   ),
//                   gradient: LinearGradient(
//                     colors: [Color(0xFF003366), Colors.blue],
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: -50,
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.white,
//                   child: CircleAvatar(
//                     radius: 45,
//                     backgroundImage: AssetImage(data[0].imagePath),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 50),
//           Expanded(
//             child: Stepper(
//               type: StepperType.vertical,
//               currentStep: _currentStep,
//               onStepContinue: _onStepContinue,
//               onStepCancel: _onStepCancel,
//               controlsBuilder: (context, details) {
//                 return Row(
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF003366),
//                       ),
//                       onPressed: details.onStepContinue,
//                       child: const Text(
//                         "Continue",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                     if (_currentStep > 0)
//                       TextButton(
//                         onPressed: details.onStepCancel,
//                         child: const Text("Back"),
//                       ),
//                   ],
//                 );
//               },
//               steps: [
//                 // Step 1: Personal Information
//                 Step(
//                   title: const Text("Personal Information"),
//                   isActive: _currentStep == 0,
//                   state: _completeSteps[0]
//                       ? StepState.complete
//                       : StepState.indexed,
//                   content: Form(
//                     key: _formKeys[0],
//                     child: Column(
//                       children: [
//                         CustomTextField(
//                           hintText: "Full Name",
//                           prefixIcon: Icons.person,
//                           validator: (value) =>
//                               value!.isEmpty ? "Required" : null,
//                           onSaved: (value) => name = value ?? "",
//                         ),
//                         CustomTextField(
//                           hintText: "Job Title",
//                           prefixIcon: Icons.work,
//                           validator: (value) =>
//                               value!.isEmpty ? "Required" : null,
//                           onSaved: (value) => jobTitle = value ?? "",
//                         ),
//                         CustomTextField(
//                           hintText: "Address",
//                           prefixIcon: Icons.home,
//                           validator: (value) =>
//                               value!.isEmpty ? "Required" : null,
//                           onSaved: (value) => address = value ?? "",
//                         ),
//                         const SizedBox(height: 20),
//                         GestureDetector(
//                           onTap: () async {
//                             DateTime? pickedDate = await showDatePicker(
//                               context: context,
//                               initialDate: DateTime.now(),
//                               firstDate: DateTime(1980),
//                               lastDate: DateTime.now(),
//                             );
//                             if (pickedDate != null) {
//                               setState(() => dateOfBirth = pickedDate);
//                             }
//                           },
//                           child: Card(
//                             color: const Color(0xFF003366),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const Icon(
//                                     Icons.calendar_today,
//                                     color: Colors.white,
//                                   ),
//                                   Text(
//                                     dateOfBirth == null
//                                         ? "Select Date"
//                                         : "${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}",
//                                     style: const TextStyle(color: Colors.white),
//                                   ),
//                                   const Icon(Icons.edit, color: Colors.white),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         const Text(
//                           "Gender",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         RadioListTile(
//                           title: const Text("Male"),
//                           value: "Male",
//                           groupValue: gender,
//                           onChanged: (value) => setState(() => gender = value),
//                         ),
//                         RadioListTile(
//                           title: const Text("Female"),
//                           value: "Female",
//                           groupValue: gender,
//                           onChanged: (value) => setState(() => gender = value),
//                         ),
//                         RadioListTile(
//                           title: const Text("Other"),
//                           value: "Other",
//                           groupValue: gender,
//                           onChanged: (value) => setState(() => gender = value),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Step 2: Work Experience
//                 Step(
//                   title: const Text("Work Experience"),
//                   isActive: _currentStep == 1,
//                   state: _completeSteps[1]
//                       ? StepState.complete
//                       : StepState.indexed,
//                   content: Form(
//                     key: _formKeys[1],
//                     child: Column(
//                       children: [
//                         CustomTextField(
//                           hintText: "Job Title",
//                           prefixIcon: Icons.work,
//                           onSaved: (value) => tempJobTitle = value ?? "",
//                         ),
//                         CustomTextField(
//                           hintText: "Company",
//                           prefixIcon: Icons.business,
//                           onSaved: (value) => tempCompany = value ?? "",
//                         ),
//                         CustomTextField(
//                           hintText: "Description",
//                           prefixIcon: Icons.description,
//                           onSaved: (value) => tempJobDescription = value ?? "",
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Step 3: Education
//                 Step(
//                   title: const Text("Education"),
//                   isActive: _currentStep == 2,
//                   state: _completeSteps[2]
//                       ? StepState.complete
//                       : StepState.indexed,
//                   content: Form(
//                     key: _formKeys[2],
//                     child: Column(
//                       children: [
//                         CustomTextField(
//                           hintText: "Degree",
//                           prefixIcon: Icons.school,
//                           onSaved: (value) => tempDegree = value ?? "",
//                         ),
//                         CustomTextField(
//                           hintText: "Institution",
//                           prefixIcon: Icons.location_city,
//                           onSaved: (value) => tempInstitution = value ?? "",
//                         ),
//                         CustomTextField(
//                           hintText: "Description",
//                           prefixIcon: Icons.description,
//                           onSaved: (value) =>
//                               tempEducationDescription = value ?? "",
//                         ),
//                         DropdownButtonFormField<String>(
//                           decoration: InputDecoration(
//                             labelText: "Education Level",
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           value: tempEducationLevel.isEmpty
//                               ? null
//                               : tempEducationLevel,
//                           items: ["Undergraduate", "Graduate", "PhD"]
//                               .map(
//                                 (level) => DropdownMenuItem(
//                                   value: level,
//                                   child: Text(level),
//                                 ),
//                               )
//                               .toList(),

//                           onChanged: (value) {
//                             setState(() => tempEducationLevel = value ?? "");
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Step 4: Skills
//                 Step(
//                   title: const Text("Skills"),
//                   isActive: _currentStep == 3,
//                   state: _completeSteps[3]
//                       ? StepState.complete
//                       : StepState.indexed,
//                   content: Form(
//                     key: _formKeys[3],
//                     child: Column(
//                       children: [
//                         CustomTextField(
//                           hintText: "Skill Name",
//                           prefixIcon: Icons.star,
//                           onSaved: (value) => tempSkill = value ?? "",
//                           validator: (value) =>
//                               value!.isEmpty ? "Required" : null,
//                         ),
//                         Slider(
//                           value: tempProficiency,
//                           min: 0,
//                           max: 1,
//                           divisions: 10,
//                           label: "${(tempProficiency * 100).round()}%",
//                           onChanged: (value) {
//                             setState(() => tempProficiency = value);
//                           },
//                         ),
//                         SizedBox(height: 8.0),
//                         Column(
//                           children: [
//                             Text(
//                               "Field of Interest",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF003366),
//                               ),
//                             ),

//                             // final interests = ["Sports", "Music", "Reading", "Gaming"];

//                             // Column(
//                             //   children: interests.map((interest) {
//                             //     return CheckboxListTile(
//                             //       title: Text(interest),
//                             //       value: selectInterset.contains(interest),
//                             //       onChanged: (value) {
//                             //         setState(() {
//                             //           if (value == true) {
//                             //             selectInterset.add(interest);
//                             //           } else {
//                             //             selectInterset.remove(interest);
//                             //           }
//                             //         });
//                             //       },
//                             //     );
//                             //   }).toList(),
//                             // )
//                             CheckboxListTile(
//                               title: const Text("Technology"),
//                               value: selectInterset.contains("Technology"),
//                               onChanged: (value) {
//                                 setState(() {
//                                   if (value == true) {
//                                     selectInterset.add("Technology");
//                                   } else {
//                                     selectInterset.remove("Technology");
//                                   }
//                                 });
//                               },
//                             ),

//                             CheckboxListTile(
//                               title: const Text("Sports"),
//                               value: selectInterset.contains("Sports"),
//                               onChanged: (value) {
//                                 setState(() {
//                                   if (value == true) {
//                                     selectInterset.add("Sports");
//                                   } else {
//                                     selectInterset.remove("Sports");
//                                   }
//                                 });
//                               },
//                             ),
//                             CheckboxListTile(
//                               title: const Text("Art"),
//                               value: selectInterset.contains("Art"),
//                               onChanged: (value) {
//                                 setState(() {
//                                   if (value == true) {
//                                     selectInterset.add("Art");
//                                   } else {
//                                     selectInterset.remove("Art");
//                                   }
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//                             if (!_isGenerating) {
//                               Positioned.fill(child: Container(
//                                 color: Colors.black.withOpacity(0.5),
//                                 child: Center(
//                                   child: Center(
//                                     child: CircularProgressIndicator(),
//                                   ),
//                                 ),
//                               ));
//                             }
//   }
// }




// lib/multi_step_form.dart
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'resume_pdf.dart';
import 'package:resumee/Custom_widget/Custom_text_field.dart';
import 'package:resumee/data/data.dart'; // used for placeholder profile image in UI

class MultiStepForm extends StatefulWidget {
  const MultiStepForm({super.key});

  @override
  State<MultiStepForm> createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  int _currentStep = 0;
  final _formKeys = List.generate(4, (_) => GlobalKey<FormState>());
  final List<bool> _completeSteps = [false, false, false, false];

  String name = "";
  String jobTitle = "";
  String address = "";
  DateTime? dateOfBirth;
  String? gender;
  String educationLevel = "";

  List<Map<String, String>> workExperience = [];
  List<Map<String, String>> educationList = [];
  List<Map<String, dynamic>> skills = [];

  String tempJobTitle = "";
  String tempCompany = "";
  String tempJobDescription = "";

  String tempDegree = "";
  String tempInstitution = "";
  String tempEducationDescription = "";
  String tempEducationLevel = "";

  String tempSkill = "";
  List<String> selectInterset = [];
  double tempProficiency = 0.5;
  bool _isGenerating = false;

  // Additional fields for PDF generation
  String email = "";
  String phone = "";
  String website = "";
  String profileImagePath = ""; // e.g. 'assets/images/profile.png' (optional)

  void _onStepContinue() {
    final isValid = _formKeys[_currentStep].currentState?.validate() ?? false;

    if (isValid) {
      _formKeys[_currentStep].currentState?.save();

      if (_currentStep == 1) {
        workExperience.add({
          "jobTitle": tempJobTitle,
          "company": tempCompany,
          "description": tempJobDescription,
        });
        tempJobTitle = "";
        tempCompany = "";
        tempJobDescription = "";
      } else if (_currentStep == 2) {
        educationList.add({
          "degree": tempDegree,
          "institution": tempInstitution,
          "description": tempEducationDescription,
          "educationLevel": tempEducationLevel,
        });
        tempDegree = "";
        tempInstitution = "";
        tempEducationDescription = "";
        tempEducationLevel = "";
      } else if (_currentStep == 3) {
        skills.add({"skill": tempSkill, "proficiency": tempProficiency});
        tempSkill = "";
        tempProficiency = 0.5;
      }

      if (_currentStep < _formKeys.length - 1) {
        setState(() {
          _completeSteps[_currentStep] = true;
          _currentStep++;
        });
      }
    }
  }

  Future<void> _generateResumePdf() async {
    setState(() {
      _isGenerating = true;
    });
    try {
      final file = await generateResume(
        PdfPageFormat.letter,
        name: name,
        email: email,
        jobTitle: jobTitle,
        address: address,
        phone: phone,
        website: website,
        profileImagePath: profileImagePath,
        workExperience: workExperience,
        educationList: educationList,
        skills: skills,
        dateOfBirth: dateOfBirth != null
            ? "${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}"
            : "Not Provided",
        gender: gender ?? "",
        interests: selectInterset,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          content: Text("PDF Generated Successfully", style: TextStyle(color: Colors.white)),
        ),
      );
      await OpenFile.open(file.path);
    } catch (e, st) {
      debugPrint("PDF generation error: $e\n$st");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text("PDF Not Generated", style: TextStyle(color: Colors.white)),
        ),
      );
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 140,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(65)),
                  gradient: LinearGradient(
                    colors: [Color(0xFF003366), Colors.blue],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage(data[0].imagePath),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Expanded(
            child: Stack(
              children: [
                Stepper(
                  type: StepperType.vertical,
                  currentStep: _currentStep,
                  onStepContinue: _onStepContinue,
                  onStepCancel: _onStepCancel,
                  controlsBuilder: (context, details) {
                    return Row(
                      children: [
                        if (_currentStep < _formKeys.length - 1)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003366)),
                            onPressed: details.onStepContinue,
                            child: const Text("Continue", style: TextStyle(color: Colors.white)),
                          )
                        else
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            onPressed: _isGenerating ? null : _generateResumePdf,
                            child: _isGenerating
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text("Generate Resume", style: TextStyle(color: Colors.white)),
                          ),
                        if (_currentStep > 0)
                          TextButton(onPressed: details.onStepCancel, child: const Text("Back")),
                      ],
                    );
                  },
                  steps: [
                    Step(
                      title: const Text("Personal Information"),
                      isActive: _currentStep == 0,
                      state: _completeSteps[0] ? StepState.complete : StepState.indexed,
                      content: Form(
                        key: _formKeys[0],
                        child: Column(
                          children: [
                            CustomTextField(
                              hintText: "Full Name",
                              prefixIcon: Icons.person,
                              validator: (value) => value!.isEmpty ? "Required" : null,
                              onSaved: (value) => name = value ?? "",
                            ),
                            CustomTextField(
                              hintText: "Job Title",
                              prefixIcon: Icons.work,
                              validator: (value) => value!.isEmpty ? "Required" : null,
                              onSaved: (value) => jobTitle = value ?? "",
                            ),
                            CustomTextField(
                              hintText: "Address",
                              prefixIcon: Icons.home,
                              validator: (value) => value!.isEmpty ? "Required" : null,
                              onSaved: (value) => address = value ?? "",
                            ),
                            const SizedBox(height: 12),
                            // CustomTextField(
                            //   hintText: "Email",
                            //   prefixIcon: Icons.email,
                            //   validator: (value) => (value != null && value.contains('@')) ? null : "Enter valid email",
                            //   onSaved: (value) => email = value ?? "",
                            // ),
                            CustomTextField(
                              hintText: "Phone",
                              prefixIcon: Icons.phone,
                              onSaved: (value) => phone = value ?? "",
                            ),
                            CustomTextField(
                              hintText: "Website (optional)",
                              prefixIcon: Icons.link,
                              onSaved: (value) => website = value ?? "",
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  setState(() => dateOfBirth = pickedDate);
                                }
                              },
                              child: Card(
                                color: const Color(0xFF003366),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(Icons.calendar_today, color: Colors.white),
                                      Text(
                                        dateOfBirth == null ? "Select Date" : "${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      const Icon(Icons.edit, color: Colors.white),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text("Gender", style: TextStyle(fontWeight: FontWeight.bold)),
                            RadioListTile<String>(
                              title: const Text("Male"),
                              value: "Male",
                              groupValue: gender,
                              onChanged: (value) => setState(() => gender = value),
                            ),
                            RadioListTile<String>(
                              title: const Text("Female"),
                              value: "Female",
                              groupValue: gender,
                              onChanged: (value) => setState(() => gender = value),
                            ),
                            RadioListTile<String>(
                              title: const Text("Other"),
                              value: "Other",
                              groupValue: gender,
                              onChanged: (value) => setState(() => gender = value),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Step(
                      title: const Text("Work Experience"),
                      isActive: _currentStep == 1,
                      state: _completeSteps[1] ? StepState.complete : StepState.indexed,
                      content: Form(
                        key: _formKeys[1],
                        child: Column(
                          children: [
                            CustomTextField(hintText: "Job Title", prefixIcon: Icons.work, onSaved: (v) => tempJobTitle = v ?? ""),
                            CustomTextField(hintText: "Company", prefixIcon: Icons.business, onSaved: (v) => tempCompany = v ?? ""),
                            CustomTextField(hintText: "Description", prefixIcon: Icons.description, onSaved: (v) => tempJobDescription = v ?? ""),
                          ],
                        ),
                      ),
                    ),

                    Step(
                      title: const Text("Education"),
                      isActive: _currentStep == 2,
                      state: _completeSteps[2] ? StepState.complete : StepState.indexed,
                      content: Form(
                        key: _formKeys[2],
                        child: Column(
                          children: [
                            CustomTextField(hintText: "Degree", prefixIcon: Icons.school, onSaved: (v) => tempDegree = v ?? ""),
                            CustomTextField(hintText: "Institution", prefixIcon: Icons.location_city, onSaved: (v) => tempInstitution = v ?? ""),
                            CustomTextField(hintText: "Description", prefixIcon: Icons.description, onSaved: (v) => tempEducationDescription = v ?? ""),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(labelText: "Education Level", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                              value: tempEducationLevel.isEmpty ? null : tempEducationLevel,
                              items: ["Undergraduate", "Graduate", "PhD"].map((level) => DropdownMenuItem(value: level, child: Text(level))).toList(),
                              onChanged: (value) => setState(() => tempEducationLevel = value ?? ""),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Step(
                      title: const Text("Skills & Interests"),
                      isActive: _currentStep == 3,
                      state: _completeSteps[3] ? StepState.complete : StepState.indexed,
                      content: Form(
                        key: _formKeys[3],
                        child: Column(
                          children: [
                            CustomTextField(hintText: "Skill Name", prefixIcon: Icons.star, validator: (v) => v!.isEmpty ? "Required" : null, onSaved: (v) => tempSkill = v ?? ""),
                            Slider(
                              value: tempProficiency,
                              min: 0,
                              max: 1,
                              divisions: 10,
                              label: "${(tempProficiency * 100).round()}%",
                              onChanged: (value) => setState(() => tempProficiency = value),
                            ),
                            const SizedBox(height: 8),
                            const Text("Fields of Interest", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
                            CheckboxListTile(
                              title: const Text("Technology"),
                              value: selectInterset.contains("Technology"),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) selectInterset.add("Technology");
                                  else selectInterset.remove("Technology");
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: const Text("Sports"),
                              value: selectInterset.contains("Sports"),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) selectInterset.add("Sports");
                                  else selectInterset.remove("Sports");
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: const Text("Art"),
                              value: selectInterset.contains("Art"),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) selectInterset.add("Art");
                                  else selectInterset.remove("Art");
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isGenerating)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
