import 'package:flutter/material.dart';

class GradientCustomizer extends StatefulWidget {
  const GradientCustomizer({super.key});

  @override
  State<GradientCustomizer> createState() => _GradientCustomizerState();
}

class _GradientCustomizerState extends State<GradientCustomizer> {
  // Gradient parameters
  double _angle = 0.0;
  List<Color> _colors = [Colors.blue, Colors.purple];
  List<double> _stops = [0.0, 1.0];
  bool _isLinear = true;
  TileMode _tileMode = TileMode.clamp;
  double _centerX = 0.5;
  double _centerY = 0.5;
  double _radius = 0.5;

  // Begin and End alignment parameters
  Alignment _begin = Alignment.centerLeft;
  Alignment _end = Alignment.centerRight;

  // Color options for demo
  final List<List<Color>> _colorPresets = [
    [Colors.blue, Colors.purple],
    [Colors.orange, Colors.pink],
    [Colors.green, Colors.yellow],
    [Colors.red, Colors.blue],
    [Colors.teal, Colors.indigo],
  ];

  // Predefined alignment options
  final List<Map<String, Alignment>> _alignmentOptions = [
    {'topLeft': Alignment.topLeft},
    {'topCenter': Alignment.topCenter},
    {'topRight': Alignment.topRight},
    {'centerLeft': Alignment.centerLeft},
    {'center': Alignment.center},
    {'centerRight': Alignment.centerRight},
    {'bottomLeft': Alignment.bottomLeft},
    {'bottomCenter': Alignment.bottomCenter},
    {'bottomRight': Alignment.bottomRight},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(236, 31, 31, 31),
      body: SafeArea(
        child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gradient Display Container
            Container(
              margin: const EdgeInsets.all(16),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: _isLinear
                    ? LinearGradient(
                        colors: _colors,
                        stops: _stops,
                        begin: _begin,
                        end: _end,
                        transform: GradientRotation(_angle * 3.14159 / 180),
                        tileMode: _tileMode,
                      )
                    : RadialGradient(
                        colors: _colors,
                        stops: _stops,
                        center: Alignment(_centerX * 2 - 1, _centerY * 2 - 1),
                        radius: _radius,
                        tileMode: _tileMode,
                      ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _isLinear ? 'Linear Gradient' : 'Radial Gradient',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 250),
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Begin Alignment Section
                    if (_isLinear) ...[
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Begin Alignment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            // spacing: 8,
                            // runSpacing: 8,
                            children: _alignmentOptions.map((option) {
                              final name = option.keys.first;
                              final alignment = option.values.first;
                              return Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: FilterChip(
                                  selected: _begin == alignment,
                                  label: Text(
                                    name,
                                    style: TextStyle(
                                      color: _begin == alignment
                                          ? Colors.white
                                          : Colors.white,
                                    ),
                                  ),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _begin = alignment;
                                    });
                                  },
                                  selectedColor: Colors.blue,
                                  checkmarkColor: Colors.white,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      // End Alignment Section
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'End Alignment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _alignmentOptions.map((option) {
                              final name = option.keys.first;
                              final alignment = option.values.first;
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: FilterChip(
                                  selected: _end == alignment,
                                  label: Text(
                                    name,
                                    style: TextStyle(
                                      color: _end == alignment
                                          ? Colors.white
                                          : Colors.white,
                                    ),
                                  ),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _end = alignment;
                                    });
                                  },
                                  selectedColor: Colors.blue,
                                  checkmarkColor: Colors.white,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],

                    // Color Presets
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Color Combinations',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14).copyWith(top: 0),
                      child: SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _colorPresets.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _colors = _colorPresets[index];
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: _colorPresets[index],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Angle Slider (for Linear)
                    if (_isLinear) ...[
                      Padding(
                        padding: const EdgeInsets.all(14).copyWith(bottom: 0),
                        child: const Text(
                          'Angle',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Slider(
                        value: _angle,
                        min: 0,
                        max: 360,
                        divisions: 360,
                        label: '${_angle.round()}°',
                        onChanged: (value) {
                          setState(() {
                            _angle = value;
                          });
                        },
                      ),
                      Center(
                        child: Text(
                          '${_angle.toStringAsFixed(2)}°',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],

                    // Stop Points
                    Padding(
                      padding: const EdgeInsets.all(14).copyWith(bottom: 0),
                      child: Row(
                        children: [
                          const Text(
                            'Color Stop 1',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: _colors[0],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          )
                        ],
                      ),
                    ),
                    Slider(
                      value: _stops[0],
                      min: 0.0,
                      max: 0.5,
                      onChanged: (value) {
                        setState(() {
                          _stops = [value, _stops[1]];
                        });
                      },
                    ),
                    Center(
                      child: Text(
                        _stops[0].toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(14).copyWith(bottom: 0),
                      child: Row(
                        children: [
                          const Text(
                            'Color Stop 2',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: _colors[1],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          )
                        ],
                      ),
                    ),
                    Slider(
                      value: _stops[1],
                      min: 0.5,
                      max: 1.0,
                      onChanged: (value) {
                        setState(() {
                          _stops = [_stops[0], value];
                        });
                      },
                    ),
                    Center(
                      child: Text(
                        _stops[1].toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
