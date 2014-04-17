precision highp float;
uniform sampler2D DiffuseMap;
uniform sampler2D NormalMap;
uniform sampler2D PgsMap;
uniform samplerCube ReflectionMap;
uniform samplerCube MaskReflectionMap;
uniform vec4 MaterialSpecularCurve;
uniform vec4 MaterialSpecularFactors;
uniform vec4 GlowColor;
uniform vec4 FresnelFactors;
uniform vec4 ReflectionFactors;
uniform vec4 MaterialReflectionColor;
uniform vec4 MaskDiffuseColor;
uniform vec4 MaskSpecularCurve;
uniform vec4 MaskSpecularFactors;
uniform vec4 MaskReflectionFactors;
uniform vec4 MaskReflectionColor;
uniform vec4 SubMaskDiffuseColor;
uniform vec4 SubMaskSpecularCurve;
uniform vec4 SubMaskSpecularFactors;
uniform vec4 SubMaskReflectionFactors;
uniform vec4 SubMaskReflectionColor;
uniform vec3 u_sunDirection;
uniform vec3 u_sunColor;
uniform vec4 MaterialDiffuseColor;
uniform float MaterialAmbientFactor;
varying lowp vec2 v_TexCoord;
varying lowp vec3 v_Normal;
varying lowp vec3 v_Tangent;
varying lowp vec3 v_Binormal;
varying lowp vec3 v_EyeDirection;
struct LightingParams {
    vec3 normalWorld;
    float diffuse;
    float specular;
    float specularDot;
    vec3 reflectDir;
    float ambientOcclusion;
    vec3 ambientBounceColor;
    float fresnel;
    float fresnelDot;
    float shadow;
};
struct MaterialParams {
    vec4 diffuseMap;
    vec4 diffuseColor;
    float ambientFactor;
    vec2 specularFactors;
    vec3 specularCurve;
    float ambientOcclusionDiffuseFactor;
    float mask;
    float subMask;
    vec3 reflectionColor;
    vec4 reflectionFactors;
};
float x0() {
    return (texture2D(PgsMap, v_TexCoord).g);
}
LightingParams x1() {
    LightingParams x2;
    vec3 x3;
    ((x3.xy) = (((texture2D(NormalMap, v_TexCoord).ga) * 2.0) - 1.0));
    ((x3.z) = sqrt((1.0 - dot((x3.xy), (x3.xy)))));
    ((x2.normalWorld) = normalize((((v_Tangent * (x3.x)) + (v_Binormal * (x3.y))) + (v_Normal * (x3.z)))));
    ((x2.shadow) = 1.0);
    ((x2.diffuse) = clamp(dot((x2.normalWorld), u_sunDirection), 0.0, 1.0));
    vec3 x4 = normalize(v_EyeDirection);
    vec3 x5 = normalize((u_sunDirection + x4));
    ((x2.specularDot) = clamp(dot((x2.normalWorld), x5), 0.0, 1.0));
    ((x2.specular) = x0());
    vec3 x6 = (-reflect(x4, (x2.normalWorld)));
    ((x2.reflectDir) = x6);
    ((x2.fresnelDot) = dot(x4, (x2.normalWorld)));
    ((x2.fresnel) = x0());
    ((x2.ambientOcclusion) = 1.0);
    ((x2.ambientBounceColor) = vec3(0.0, 0.0, 0.0));
    return x2;
}
MaterialParams x7() {
    MaterialParams x8;
    ((x8.diffuseMap) = texture2D(DiffuseMap, v_TexCoord));
    ((x8.diffuseColor) = MaterialDiffuseColor);
    ((x8.ambientFactor) = MaterialAmbientFactor);
    ((x8.specularFactors) = (MaterialSpecularFactors.xy));
    ((x8.specularCurve) = (MaterialSpecularCurve.xyz));
    ((x8.reflectionColor) = (MaterialReflectionColor.rgb));
    ((x8.reflectionFactors) = ReflectionFactors);
    ((x8.mask) = (texture2D(PgsMap, v_TexCoord).b));
    ((x8.subMask) = (texture2D(PgsMap, v_TexCoord).r));
    return x8;
}
vec4 x9(vec4 x10, vec4 x11, float x12) {
    return ((x10 * (1.0 - x12)) + (x11 * x12));
}
vec3 x9(vec3 a, vec3 b, float x) {
    return ((a * (1.0 - x)) + (b * x));
}
float x9(float a, float b, float x) {
    return ((a * (1.0 - x)) + (b * x));
}
vec4 x13(LightingParams x14, MaterialParams x15) {
    vec4 x16 = ((x15.diffuseMap) * (x15.diffuseColor));
    vec3 x17 = ((vec3((x15.ambientFactor), (x15.ambientFactor), (x15.ambientFactor)) * 100.0) / 255.0);
    (x17 *= (x14.ambientOcclusion));
    (x17 += (x14.ambientBounceColor));
    float x18 = ((((x15.specularCurve).z) * pow((x14.specularDot), ((x15.specularCurve).x))) + pow((x14.specularDot), ((x15.specularCurve).y)));
    (x18 *= ((x14.specular) * (x14.shadow)));
    vec3 x19 = (((x16.rgb) * ((((x14.diffuse) + (((x15.specularFactors).y) * x18)) * u_sunColor) + x17)) + ((((x15.specularFactors).x) * x18) * u_sunColor));
    return vec4(x19, (x16.a));
}
vec3 x20(LightingParams x21, MaterialParams x22, samplerCube x23) {
    vec3 x24 = (textureCube(x23, (x21.reflectDir)).rgb);
    float x25 = ((((x24.r) * 0.299) + ((x24.g) * 0.587)) + ((x24.b) * 0.114));
    float x26 = (x21.specular);
    vec3 x27 = (x26 * x9(vec3(x25, x25, x25), x24, ((x22.reflectionFactors).z)));
    (x27 *= x9((x21.diffuse), 1.0, ((x22.reflectionFactors).w)));
    return (x27 * (((x22.reflectionFactors).x) + (((x22.reflectionFactors).y) * (x22.reflectionColor))));
}
vec3 x28(vec3 x29, LightingParams x30, vec2 x31) {
    float x32 = pow((1.0 - abs((x30.fresnelDot))), (x31.x));
    return (((((x31.y) * (x30.fresnel)) * (x30.shadow)) * x32) * x29);
}
void main(void) {
    LightingParams x33 = x1();
    MaterialParams x34 = x7();
    vec4 x35 = x13(x33, x34);
    ((x35.rgb) += x20(x33, x34, ReflectionMap));
    ((x35.rgb) += x28((x35.rgb), x33, (FresnelFactors.xy)));
    if (((x34.mask) != 0.0)) {
        ((x34.diffuseColor) = x9(SubMaskDiffuseColor, MaskDiffuseColor, (x34.subMask)));
        ((x34.specularCurve) = (x9(SubMaskSpecularCurve, MaskSpecularCurve, (x34.subMask)).xyz));
        ((x34.reflectionColor) = (x9(SubMaskReflectionColor, MaskReflectionColor, (x34.subMask)).xyz));
        ((x34.reflectionFactors) = x9(SubMaskReflectionFactors, MaskReflectionFactors, (x34.subMask)));
        ((x34.specularFactors) = (x9(SubMaskSpecularFactors, MaskSpecularFactors, (x34.subMask)).xy));
        vec4 x36 = x13(x33, x34);
        ((x36.rgb) += x20(x33, x34, MaskReflectionMap));
        ((x36.rgb) += x28((x36.rgb), x33, (FresnelFactors.xy)));
        ((x35.rgb) = x9((x35.rgb), (x36.rgb), (x34.mask)));
    }
    float x37 = (texture2D(PgsMap, v_TexCoord).a);
    ((x35.rgb) += ((GlowColor.rgb) * vec3(x37, x37, x37)));
    ((x35.a) = 1.0);
    (gl_FragColor = x35);
}
