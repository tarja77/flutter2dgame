import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flametest/pixel_adventure.dart';

class Saw extends SpriteAnimationComponent with HasGameRef<PixelAdventure> {
  final TiledObject tiledObject;

  Saw({required this.tiledObject});
  
  double sawSpeed = 0.03;
  bool isVeritical=false;
  double offNeg=0;
  double offPos=0;

  static const moveSpeed =50;
  static const tileSize =16;
  double moveDirection =1;
  double rangeNeg=0;
  double rangePos=0;

  @override
  FutureOr<void> onLoad() {
    isVeritical =tiledObject.properties.getValue("isVeritical")??false;
    offNeg =tiledObject.properties.getValue("offNeg")??0;
    offPos =tiledObject.properties.getValue("offPos")??0;
    sawSpeed =tiledObject.properties.getValue("sawSpeed")??0.03;
    position = Vector2(tiledObject.x, tiledObject.y);
    size = Vector2(tiledObject.width, tiledObject.height);
    priority=-1;
    add(CircleHitbox());
    if(isVeritical){
      rangeNeg = position.y-offNeg*tileSize;
      rangePos = position.y+offPos*tileSize;
    }else{
      rangeNeg = position.x -offNeg*tileSize;
      rangePos = position.x +offPos*tileSize;
    }
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Traps/Saw/On (38x38).png'),
        SpriteAnimationData.sequenced(amount: 8, stepTime: sawSpeed, textureSize: Vector2.all(38)));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if(isVeritical){
      _moveVetirical(dt);
    }else{
      _moveHorizontally(dt);
    }

    super.update(dt);
  }

  void _moveVetirical(double dt) {
    if(position.y>=rangePos){
      moveDirection=-1;
    }else if(position.y<=rangeNeg){
      moveDirection= 1;
    }
    position.y+=moveDirection*moveSpeed*dt;
  }

  void _moveHorizontally(double dt) {
    if(position.x>=rangePos){
      moveDirection=-1;
    }else if(position.x<=rangeNeg){
      moveDirection= 1;
    }
    position.x+=moveDirection*moveSpeed*dt;
  }
}