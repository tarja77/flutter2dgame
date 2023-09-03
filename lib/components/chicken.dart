import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flametest/pixel_adventure.dart';

enum State { idle, run, hit }

class Chicken extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure> {
  TiledObject tiledObject;

  Chicken({required this.tiledObject});

  double offNeg = 0;
  double offPos = 0;
  String enemy = "Chicken";
  static const stepTime = 0.05;
  static const tileSize = 16;
  final textureSize = Vector2(32, 34);
  double rangeNeg = 0;
  double rangePos = 0;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _hitAnimation;

  @override
  FutureOr<void> onLoad() {
    offNeg = tiledObject.properties.getValue("offNeg");
    offPos = tiledObject.properties.getValue("offPos");
    enemy = tiledObject.properties.getValue("enemy")??'Chicken';
    position = Vector2(tiledObject.x, tiledObject.y);
    size = Vector2(tiledObject.width, tiledObject.height);
    debugMode = true;
    _loadAllAnimations();
    _calculateRange();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _movement(dt);
    super.update(dt);
  }

  void _loadAllAnimations() {
    _idleAnimation = _spriteAnimation('Idle', 13);
    _runAnimation = _spriteAnimation('Run', 14);
    _hitAnimation = _spriteAnimation('Hit', 5)..loop = false;
    animations = {
      State.idle: _idleAnimation,
      State.run: _runAnimation,
      State.hit: _hitAnimation,
    };
    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache("Enemies/$enemy/$state (32x34).png"),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: textureSize));
  }

  void _calculateRange() {
    rangeNeg = position.x - offNeg * tileSize;
    rangePos = position.x - offPos * tileSize;
  }

  void _movement(double dt) {
    //set velocity zero
  }
}
