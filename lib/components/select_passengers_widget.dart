import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectPassengersWidget extends StatefulWidget {
  const SelectPassengersWidget({
    super.key,
    required this.onPassengersSelected,
  });
  final ValueChanged<int> onPassengersSelected;
  @override
  State<SelectPassengersWidget> createState() => _SelectPassengersWidgetState();
}

class _SelectPassengersWidgetState extends State<SelectPassengersWidget> {
  int _passengers = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      // height: size.height * 0.35,
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          SizedBox(
              height: size.height * 0.07,
              child: Row(
                children: const [
                  Icon(
                    CupertinoIcons.person,
                    size: 30,
                    color: CupertinoColors.activeBlue,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Passengers',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              )),
          const Divider(
            color: Colors.grey,
          ),
          SizedBox(
              height: size.height * 0.1,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (_passengers > 0) _passengers--;
                        });
                      },
                      child: const Icon(
                        CupertinoIcons.minus_circled,
                        size: 35,
                        color: CupertinoColors.black,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          '$_passengers',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      )),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _passengers++;
                        });
                      },
                      child: const Icon(
                        CupertinoIcons.add_circled,
                        size: 35,
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                  ),
                ],
              )),
          const Divider(
            color: Colors.transparent,
          ),
          SizedBox(
              height: size.height * 0.04, child: const SizedBox.shrink()),
          const Divider(
            color: Colors.transparent,
          ),
          SizedBox(
            height: size.height * 0.07,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      CupertinoColors.activeBlue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ))),
              onPressed: () {
                widget.onPassengersSelected(_passengers);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                      child: Text(
                    'Select',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
