import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InitialeSearchWidget extends StatelessWidget {
  const InitialeSearchWidget({
    super.key,
    required this.onSearchPressed,
    required this.onPassengersPressed,
    required this.onDatePressed,
    required this.onPickPressed,
    required this.onDestinationPressed,
    required this.onSwitchClick,
    required this.passenger,
    required this.date,
    required this.pickAddress,
    required this.destinationAddress,
  });

  final VoidCallback onSearchPressed;
  final VoidCallback onPassengersPressed;
  final VoidCallback onDatePressed;
  final VoidCallback onPickPressed;
  final VoidCallback onDestinationPressed;
  final VoidCallback onSwitchClick;

  final String? passenger;
  final String? date;
  final String? pickAddress;
  final String? destinationAddress;

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
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                  height: size.height * 0.07,
                  child: InkWell(
                    onTap: () {
                      onPickPressed();
                    },
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.play,
                          size: 30,
                          color: CupertinoColors.activeBlue,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(pickAddress ?? 'Pick up location',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  )),
              const Divider(
                color: Colors.grey,
              ),
              SizedBox(
                  height: size.height * 0.07,
                  child: InkWell(
                    onTap: onDestinationPressed,
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.circle,
                          size: 30,
                          color: CupertinoColors.activeBlue,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(destinationAddress ?? 'Destination',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  )),
              const Divider(
                color: Colors.grey,
              ),
              SizedBox(
                  height: size.height * 0.07,
                  child: InkWell(
                    onTap: onDatePressed,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 10,
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.calendar,
                                  size: 30,
                                  color: CupertinoColors.activeBlue,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Text(date ?? 'Date',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            )),
                        const VerticalDivider(
                          color: Colors.grey,
                        ),
                        Expanded(
                            flex: 9,
                            child: InkWell(
                              onTap: onPassengersPressed,
                              child: Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.person,
                                    size: 30,
                                    color: CupertinoColors.activeBlue,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Text(passenger ?? 'Passengers',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  )),
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
                  onPressed: onSearchPressed,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(
                          child: Text(
                        'Search',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: size.height * 0.07 - 15,
            right: 0,
            child: IconButton(
              onPressed: onSwitchClick,
              icon: const CircleAvatar(
                backgroundColor: CupertinoColors.systemGrey5,
                child: Icon(
                  CupertinoIcons.arrow_2_circlepath,
                  color: CupertinoColors.activeBlue,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
