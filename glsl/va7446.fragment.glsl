#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec2 center = vec2(0.5,0.5);
float speed = 0.035;
float invAr = resolution.y / resolution.x;
void main(void)
{

	//gl_FragColor = vec4(col*texcol,1.0);
	//gl_FragColor = vec4(texcol,1.0);
	
	// Exact distortion parameters (a, b, c) are not known yet, these are just placeholers
	float a = 0.20;
	float b = 0.00;
	float c = 0.00;
	float d = 1.0 - (a + b + c);
	// Calculate the source location radius (distance from the centre of the viewport)
	// fragPos - xy position of the current fragment (destination) in NDC space [-1 1]^2
	vec2 texcoord = vec2(gl_FragCoord) + vec2(0.0, 0.0);
	float destR = length(texcoord);
	float srcR = a * pow(destR,4.0) + b * pow(destR,3.0) + c * pow(destR,2.0) + d * destR;
	// Calculate the source vector (radial)
	vec2 correctedRadial = (normalize(texcoord)) * (srcR);
	// Transform the coordinates (from [-1,1]^2 to [0, 1]^2)
	vec2 uv = (correctedRadial*0.5) + vec2(0.5,0.5); 
	vec3 col = vec4(uv,0.5+0.5*sin(time),1.0).xyz;

	// Sample the texture at the source location
	gl_FragColor = vec4(col, 1.0); 

}

