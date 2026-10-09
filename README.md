# FFE2 (Fxll3n's Fight Engine 2)

A high-performance collision detection plugin built natively for Godot 4. This is a complete architecture remake of the original [FFE (FightEngine)](https://github.com/Fxll3n/FightEngine) plugin.

## Why Use FFE2?

The FFE plugin line is designed to simplify the creation and detection of hitboxes for fighting games or any action-heavy genre. FFE follows an **animation-driven** approach to hitboxes, where animation keyframes dynamically modify the Collider's properties to achieve an effect similar to traditional frame-data.

### What makes FFE2 better than FFE?

The original FFE relied heavily on `area_entered` and `area_exited` signals for collision detection. This approach often created bottlenecks on Godot's signal bus and physics engine callbacks. 

FFE2 solves this by introducing a **query-tick based system**:
* **Direct Server Queries:** `CollisionBox2D` checks for collisions at a configurable tick-rate directly via `PhysicsDirectSpaceState2D.intersect_shape()`. 
* **Bypass the Bus:** By querying the physics server directly for intersections on that exact tick, the engine bypasses signal processing entirely.
* **Improved Precision:** This method is significantly more precise than standard signal callbacks and offers greater flexibility for integrating into your own custom interaction systems.

> [!WARNING]
> **Multiplayer Notice:** If you are building a multiplayer game, please do not use the `AnimationPlayer` for hitbox logic. Animations are not a consistent source of truth across different clients.

## Installation

1. Download the latest version of the plugin from the repository.
2. Place the `ffe2` folder into your Godot project's `addons/` directory.
3. Open your project, go to **Project > Project Settings > Plugins**, and check the "Enable" box next to FFE2.

## Ackowledgements
### Examples Assets:
- **[Kenney's Scribble Platformer Assets](https://kenney.nl/assets/scribble-platformer)**: Licensed under the Creative Commons CC0 license.
- **[Voxy's @icons Icon Pack](https://store.godotengine.org/asset/voxy/at-icons/)**: Licensed under the MIT license.
- **[GDQuest's GoBot Model'](https://github.com/gdquest-demos/godot-4-3D-Characters)**: All godot resources (scripts, scenes, etc.) are licensed under the MIT license. The Model and art assets are licensed under the Creative Commons [CC-BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).

## Roadmap

- [ ] **TickManager Autoload:** A centralized system to manage ticks and tick-based callbacks without relying on signals.
- [ ] **Multiplayer Friendly:** Refactoring and enhancements to ensure the system plays nicely with netcode.
- [ ] **"True" Frame-Data System:** An alternative collision system based purely on frame-data rather than animation keyframes.

## Contributing

Contributions are always welcome! You are highly encouraged to submit PRs for any issues you fix or new features you would like added. 

*Please note: I am a student and the sole maintainer of this project, so I may not always be able to review requests immediately. Thank you for your patience and support!*
