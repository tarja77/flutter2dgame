import 'dart:async';
import 'dart:io';


import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flametest/components/jump_button.dart';
import 'package:flutter/cupertino.dart';

import 'components/player.dart';
import 'components/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks,HasCollisionDetection,TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

    late Player player;
  late  CameraComponent cam;

  late JoystickComponent joystick;
  bool showControls=Platform.isIOS||Platform.isAndroid;
  bool playSounds=true;
  double soundVolume=1.0;
  List<String> levelNames =['Level-01','Level-02'];
  int currentLevelIndex=0;
  @override
  FutureOr<void> onLoad() async {

    await images.loadAllImages();
 _loadLevel();

    if(showControls){
      addJoystick();
      add(JumpButton());
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if(showControls){
      updateJoystick();

    }

    super.update(dt);
  }
  void addJoystick() {
    joystick = JoystickComponent(
      priority: 10,
        knob: SpriteComponent(sprite: Sprite(images.fromCache('HUD/knob.png'))),
        background: SpriteComponent(
            sprite: Sprite(images.fromCache('HUD/joystick.png'))),
        margin: const EdgeInsets.only(left: 32, bottom: 32));
    add(joystick);
  }

  void updateJoystick() {
    switch(joystick.direction){
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement=-1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
      player.horizontalMovement=1;
        break;

      default:
        player.horizontalMovement=0;
    }
  }
  void loadNextLevel() {
    removeWhere((component) => component is Level);

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      // no more levels
      currentLevelIndex = 0;
      _loadLevel();
    }
  }

  void _loadLevel() {
    player=Player(character: 'Mask Dude');
    Future.delayed(const Duration(seconds: 1),(){
      Level world =Level(levelName: levelNames[currentLevelIndex], player: player);
      cam = CameraComponent.withFixedResolution(
          world: world, width: 640, height: 360);
      cam.viewfinder.anchor = Anchor.topLeft;
      addAll([cam, world]);
    });

  }
}
