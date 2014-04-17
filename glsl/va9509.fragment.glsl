// ignore all this
#ifdef GL_ES
precision mediump float;
#endif

// ignore this
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// supply position and normals (I'm just using these for test)
vec3 position = vec3(mouse.x, mouse.y, 1.0);
vec3 normal   = vec3(mouse.x, mouse.y, mouse.x);

// Cg conversion notes:
//  vec3 is just float3
//  void main(void) becomes Output main(Input) { }
//  *'s need to become mul(float4, float4)
//  Output will become a struct Output { float4 col : COL; };
//  Input will become a struct Input { float4 position : POSITION; float4 normal; }; // you'll need to ignore the .w
//  all things will be referenced with Input.member instead of how I did it here in GLSL
void main( void ) {
	vec3 n = normalize(normal);
	float l = 0.5 + max(0.0, pow(dot(vec3(1.0, 0.0, 0.0), n)*3.0, 4.0))*0.5;
	float v = dot(normalize(-position), n); v = clamp(pow(v*3.0, 20.0), 0.0, 1.0)*l;
			    
	gl_FragColor = vec4(v, v, v, 1.0); // in Cg FragColor is OUT

}