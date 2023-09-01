import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flametest/components/player.dart';
import 'package:flametest/pixel_adventure.dart';

class Checkpoint extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final TiledObject tiledObject;

  Checkpoint({required this.tiledObject});

  bool reachedCheckpoint = false;

  @override
  FutureOr<void> onLoad() {
    position = Vector2(tiledObject.x, tiledObject.y);
    size = Vector2(tiledObject.width, tiledObject.height);
    add(RectangleHitbox(
        position: Vector2(18, 96),
        size: Vector2(12, 8),
        collisionType: CollisionType.passive));
    animation = SpriteAnimation.fromFrameData(
        game.images
            .fromCache('Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'),
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 1, textureSize: Vector2.all(64)));
    return super.onLoad();
  }

  void reachedCheckPoint() {
    if(!reachedCheckpoint){
      reachedCheckpoint=true;
      animation = SpriteAnimation.fromFrameData(
          game.images.fromCache(
              'Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'),
          SpriteAnimationData.sequenced(
              amount: 26,
              stepTime: 0.05,
              textureSize: Vector2.all(64),
              loop: false));
    }

  }
}
