import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController rollC = TextEditingController();
  final TextEditingController birthC = TextEditingController();
  final TextEditingController aadhaarC = TextEditingController();

  DateTime? selectedDate;

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF623B00), // warna coklat dari figma
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        birthC.text =
            "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/"
            "${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =======================
      // APPBAR
      // =======================
      appBar: AppBar(
        backgroundColor: const Color(0xFF623B00),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // =======================
              // PROFILE AVATAR (Logo Anda digunakan)
              // =======================
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: const Color(0xFFF4E8E8),
                    backgroundImage: const AssetImage("assets/images/logo.png"),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF623B00),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // =======================
              // NAME
              // =======================
              fieldLabel("Name"),
              buildField(nameC, hint: "XXXXXXXXXXXX"),

              const SizedBox(height: 16),

              // =======================
              // EMAIL
              // =======================
              fieldLabel("Email"),
              buildField(
                emailC,
                hint: "xxxxxxx@gmail.com",
                suffix: const Icon(Icons.email_outlined),
              ),

              const SizedBox(height: 16),

              // =======================
              // ROLL NUMBER
              // =======================
              fieldLabel("Roll Number"),
              buildField(rollC, hint: "202XXXXX"),

              const SizedBox(height: 16),

              // =======================
              // DATE OF BIRTH
              // =======================
              fieldLabel("Date of Birth"),
              GestureDetector(
                onTap: pickDate,
                child: AbsorbPointer(
                  child: buildField(
                    birthC,
                    hint: "23/05/19XX",
                    suffix: const Icon(Icons.keyboard_arrow_down),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =======================
              // AADHAAR NUMBER
              // =======================
              fieldLabel("Aadhaar Number"),
              buildField(aadhaarC, hint: "3802 0999 XXXX"),

              const SizedBox(height: 30),

              // =======================
              // SAVE BUTTON
              // =======================
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF623B00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Save changes",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // =======================
  // LABEL FIELD
  // =======================
  Widget fieldLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  // =======================
  // TEXT FIELD (CUSTOM)
  // =======================
  Widget buildField(
    TextEditingController controller, {
    String? hint,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
      ),
    );
  }
}
