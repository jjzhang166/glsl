precision highp float;

//mod: nnorm


//nikoclass: playing with FXAA.
//You can use this function in your shaders too!

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define FXAA_REDUCE_MIN (1.0/ 128.0)
#define FXAA_REDUCE_MUL (1.0 / 8.0)
#define FXAA_SPAN_MAX 8.0
vec4 getColor(vec2 position);
vec4 applyFXAA(vec2 fragCoord)
{
    vec4 color;
    vec2 inverseVP = vec2(1.0 / resolution.x, 1.0 / resolution.y);
    vec3 rgbNW = getColor((fragCoord + vec2(-1.0, -1.0)) * inverseVP).xyz;
    vec3 rgbNE = getColor((fragCoord + vec2(1.0, -1.0)) * inverseVP).xyz;
    vec3 rgbSW = getColor((fragCoord + vec2(-1.0, 1.0)) * inverseVP).xyz;
    vec3 rgbSE = getColor((fragCoord + vec2(1.0, 1.0)) * inverseVP).xyz;
    vec3 rgbM = getColor(fragCoord * inverseVP).xyz;
    vec3 luma = vec3(0.299, 0.587, 0.114);
    float lumaNW = dot(rgbNW, luma);
    float lumaNE = dot(rgbNE, luma);
    float lumaSW = dot(rgbSW, luma);
    float lumaSE = dot(rgbSE, luma);
    float lumaM = dot(rgbM, luma);
    float lumaMin = min(lumaM, min(min(lumaNW, lumaNE), min(lumaSW, lumaSE)));
    float lumaMax = max(lumaM, max(max(lumaNW, lumaNE), max(lumaSW, lumaSE)));
    
    vec2 dir;
    dir.x = -((lumaNW + lumaNE) - (lumaSW + lumaSE));
    dir.y = ((lumaNW + lumaSW) - (lumaNE + lumaSE));
    
    float dirReduce = max((lumaNW + lumaNE + lumaSW + lumaSE) *
                          (0.25 * FXAA_REDUCE_MUL), FXAA_REDUCE_MIN);
    
    float rcpDirMin = 1.0 / (min(abs(dir.x), abs(dir.y)) + dirReduce);
    dir = min(vec2(FXAA_SPAN_MAX, FXAA_SPAN_MAX),
              max(vec2(-FXAA_SPAN_MAX, -FXAA_SPAN_MAX),
              dir * rcpDirMin)) * inverseVP;
      
    vec3 rgbA = 0.5 * (
        getColor(fragCoord * inverseVP + dir * (1.0 / 3.0 - 0.5)).xyz +
        getColor(fragCoord * inverseVP + dir * (2.0 / 3.0 - 0.5)).xyz);
    vec3 rgbB = rgbA * 0.5 + 0.25 * (
        getColor(fragCoord * inverseVP + dir * -0.5).xyz +
        getColor(fragCoord * inverseVP + dir * 0.5).xyz);
    float lumaB = dot(rgbB, luma);
    if ((lumaB < lumaMin) || (lumaB > lumaMax))
        color = vec4(rgbA, 1.0);
    else
        color = vec4(rgbB, 1.0);
    return color;
}
vec4 getColor(vec2 position) {
	float l = length(position)*3.;
	float a = atan(position.y,position.x);
	a *= sign(fract(l*2.5+1.125)-.5);
	a += time * 0.05;
	a = a/3.1415926535*floor(l+.5)*3.;
	
	
	vec2 pos2 = vec2(
		fract(a)-.5,
		fract(l+.5)-.5
	);
	
	pos2 *= mat2(.96,.28,-.28,.96);
	pos2 = abs(pos2);
	float d = max(pos2.x,pos2.y);
	
	float color = l > .5 && fract(l*.5-.25) < .5 && l < 1000.? step(abs(d-0.3),.4) * sign(fract(a*2.5)-.5) * .5 + .5 : .5;
	return vec4(vec3(pow(color,.7)),1.);
}




void main( void ) {
		
	vec2 position = ( gl_FragCoord.xy  - resolution.xy*.5 ) / resolution.y;
	//without AA
	//gl_FragColor = getColor(position);
	
	
	//with FXAA
	position.x *= resolution.x/resolution.y;
	gl_FragColor = applyFXAA(position * resolution.y);
	

}