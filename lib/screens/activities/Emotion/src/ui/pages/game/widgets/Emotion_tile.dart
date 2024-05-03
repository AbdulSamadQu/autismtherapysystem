
import 'dart:math' as math;
import 'package:autismx/shared/local/colors.dart';
import 'package:flutter/material.dart';
import '../../../../domain/models/tile.dart';
import '../controller/game_state.dart';




/// widget to render every tile in the puzzle
class EmotionTile extends StatefulWidget {
  final Tile tile;
  final String imageTile;
  final double size;
  final VoidCallback onTap;
  final bool showNumbersInTileImage;
  final GameStatus gameStatus;

  const EmotionTile({
    Key key,
    @required this.tile,
    @required this.size,
    @required this.onTap,
    @required this.imageTile,
    @required this.showNumbersInTileImage,
    @required this.gameStatus,
  }) : super(key: key);

  @override
  State<EmotionTile> createState() => _PuzzleTileState();
}

class _PuzzleTileState extends State<EmotionTile> with SingleTickerProviderStateMixin {
   AnimationController _controller;
   Animation<double> _angle;
  bool _rotating = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _angle = TweenSequence<double>(
      [
        TweenSequenceItem(
          tween: Tween(
            begin: 0,
            end: 180 * math.pi / 180,
          ),
          weight: 0.1,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: 180 * math.pi / 180,
            end: 180 * math.pi / 180,
          ),
          weight: 0.2,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: 180 * math.pi / 180,
            end: 270 * math.pi / 180,
          ),
          weight: 0.1,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: 270 * math.pi / 180,
            end: 0,
          ),
          weight: 0.1,
        ),
      ],
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rotating = false;
      }
    });
  }

  @override
  void didUpdateWidget(covariant EmotionTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.gameStatus == GameStatus.created && widget.gameStatus == GameStatus.playing) {
      _rotating = true;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
    return AnimatedPositioned(
      duration: const Duration(
        milliseconds: 200,
      ),
      left: (widget.tile.position.x - 1) * widget.size ,
      top: (widget.tile.position.y -1) * widget.size ,
      child: GestureDetector(
        onTap: () {
          if (!_rotating) {
            widget.onTap();
          }
        },
        child: AnimatedBuilder(
          animation: _angle,
          builder: (_, child) => Transform(
            transform: Matrix4.identity()
              ..rotateY(
                _angle.value,
              ),
            alignment: Alignment.center,
            child: child,
          ),
          child: ClipRRect(
            
            child: Container(
              color: Colors.white,
              width: widget.size ,
              height: widget.size,
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 200,
                ),
                child:
                     Stack(
                        key: Key(
                          widget.imageTile.hashCode.toString(),
                        ),
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              widget.imageTile,
                              fit: BoxFit.fill,
                            ),
                          ),
                          if (widget.showNumbersInTileImage)
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                color:lightColor,
                                width: widget.size * 0.25,
                                height: widget.size * 0.25,
                                padding: const EdgeInsets.all(2),
                                alignment: Alignment.center,
                                child: Text(
                                  widget.tile.value.toString(),
                                  style: TextStyle(
                                    fontSize: widget.size * 0.15,
                                  ),
                                ),
                              ),
                            )
                        ],
                      )
                   
              ),
            ),
          ),
        ),
      ),
    );
  }
}
