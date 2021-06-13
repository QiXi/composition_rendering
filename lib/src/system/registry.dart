import '../../systems.dart';

mixin Registry {
  SystemRegistry get systems => SystemRegistry.instance;

  Parameters get parameters => systems.parameters;
}

class SystemRegistry {
  static SystemRegistry instance =
      SystemRegistry(parameters: Parameters(), assetSystem: InternalAssetSystem());

  final Parameters parameters;

  final RenderSystem renderSystem;
  final UpdateSystem updateSystem;
  final FactorySystem factorySystem;
  final TextureSystem textureSystem;
  final CameraSystem cameraSystem;
  final TextSystem textSystem;
  final AssetSystem assetSystem;
  final DebugSystem debugSystem;

  SystemRegistry(
      {required Parameters parameters,
      required AssetSystem assetSystem,
      RenderSystem? renderSystem,
      UpdateSystem? updateSystem,
      FactorySystem? factorySystem,
      TextureSystem? textureSystem,
      CameraSystem? cameraSystem,
      TextSystem? textSystem,
      DebugSystem? debugSystem})
      : parameters = parameters,
        renderSystem = renderSystem ?? RenderSystem(),
        updateSystem = updateSystem ?? UpdateSystem(),
        factorySystem = factorySystem ?? FactorySystem(),
        textureSystem = textureSystem ?? TextureSystem(),
        cameraSystem = cameraSystem ?? CameraSystem(),
        textSystem = textSystem ?? TextSystem(),
        assetSystem = assetSystem,
        debugSystem = debugSystem ?? DebugSystem();

  @override
  String toString() {
    return 'SystemRegistry{ $parameters [$hashCode]}';
  }
}
