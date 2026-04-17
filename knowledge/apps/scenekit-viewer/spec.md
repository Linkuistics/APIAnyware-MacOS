# SceneKit Viewer

3D scene viewer with a rotating geometry the user can swap (cube / sphere /
torus / cylinder) and recolor via NSColorPanel. First sample app to exercise
SceneKit end-to-end and the first to exercise a protocol-inherited method
(`runAction:` lives on the SCNActionable protocol, not on SCNNode itself).

## Layout

- Window 640 × 480, titled / closable / miniaturizable / resizable, min 480 ×
  360.
- Toolbar (top, 32pt): geometry-picker `NSPopUpButton` (Cube, Sphere, Torus,
  Cylinder), "Color…" `NSButton`, all baseline-aligned inside an `NSStackView`
  pinned to the window top.
- `SCNView` fills the remaining area, autoresizing in both directions.
  `allowsCameraControl = #t` gives the user mouse-orbit and scroll-zoom for
  free, so the app needs no custom NSView/SCNView subclass and no manual
  camera placement.

## Interactions

1. Launch → rotating cube visible, lit, orbitable.
2. Geometry picker → geometry on the node swaps; rotation continues.
3. Color… → `NSColorPanel` opens; continuous mode, so changes apply as the
   user drags through the color wheel / sliders. The material's diffuse
   `contents` is updated each change; the panel's color is normalised to
   device-RGB before component access (per the Drawing Canvas precedent —
   pattern/greyscale colors raise on component accessors).
4. Mouse drag → orbit camera (built-in `allowsCameraControl`).
5. Scroll → zoom (built-in).

## API surface

| API | Usage |
|-----|-------|
| `SCNView` | 3D viewport; `setScene:`, `setAllowsCameraControl:`, `setBackgroundColor:` |
| `SCNScene` | Root scene container; `scene` factory, `rootNode` |
| `SCNNode` | Geometry node; `nodeWithGeometry:`, `addChildNode:`, `setGeometry:`, `runAction:` (via raw `tell` — SCNActionable protocol gap) |
| `SCNBox` | `boxWithWidth:height:length:chamferRadius:` |
| `SCNSphere` | `sphereWithRadius:` |
| `SCNTorus` | `torusWithRingRadius:pipeRadius:` |
| `SCNCylinder` | `cylinderWithRadius:height:` |
| `SCNMaterial` | `firstMaterial` on geometry, `diffuse` property |
| `SCNMaterialProperty` | `setContents:` with an NSColor |
| `SCNAction` | `rotateByX:y:z:duration:`, `repeatActionForever:` |
| `NSPopUpButton` | Geometry picker; `indexOfSelectedItem` |
| `NSColorPanel` | Continuous color picker, target-action wiring |

## Novel patterns

- **First app to exercise SceneKit end-to-end.** Verifies the generator
  pipeline for a mid-tier framework reaches the "loads cleanly + actually
  works" bar set by the runtime-load harness.
- **First protocol-inherited method via raw `tell`.** `SCNNode.runAction:`
  lives on the SCNActionable protocol and is not emitted on the SCNNode
  class binding. Similarly, `SCNView.setAutoenablesDefaultLighting:` lives
  on SCNSceneRenderer. Both are invoked via raw `tell` — same pattern as
  Drawing Canvas used for NSEvent, but the root cause is protocol
  inheritance, not class/instance name collision. A scoped-to-racket-oo
  core-backlog entry already exists for superclass-inherited methods
  ("Emit inherited methods from NSView/NSControl superclasses…"); the
  protocol-inheritance gap has the same shape.
- **No SCNVector3 required.** Every position the app cares about is either
  origin (geometry node) or auto-placed (camera via `allowsCameraControl`,
  lighting via material's omnidirectional ambient). Rotation uses
  `rotateByX:y:z:duration:` which takes scalar CGFloats, not a vector.
  This avoids the `_SCNVector3` cstruct gap in `type-mapping.rkt` entirely
  — deferred per the portfolio spec's implementation decision.
- **Geometry swap preserves running action.** Setting `node.geometry` to a
  new geometry object keeps the in-flight rotation `runAction:` executing
  on the node, so the animation is uninterrupted during a picker change.

## VM test strategy

1. Launch → window shows, 3D viewport non-blank (screenshot has non-uniform
   center region — SceneKit rendered something).
2. Geometry picker → select Sphere → screenshot region differs from the
   cube baseline (non-trivial geometry swap detection via OCR / pixel
   comparison).
3. Color… → `NSColorPanel` opens; pick red → screenshot shows red-tinted
   geometry.
4. Animation check → two screenshots 0.5s apart differ (rotation is active).
