/**
Change log:
- First version of fake 3D space
- Unormalize space and coordinates
- shift origin to center
**/

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 coord;

vec3 scale = vec3(1.0);
vec3 translation = vec3(0.0);

vec3 particle(vec3 pos){
	pos += translation;
	pos *= scale;
	
	// unormalize space
	pos.x *= resolution.x/resolution.y;
	pos.x *= resolution.y/resolution.x;
	

	
	// use 'z' to fake the position and size
	float depth = pos.z + 1.0;
	depth *= scale.x;
	pos.xy *= (depth);
	float multiplier = 0.0001 * (depth);
	
	float diffX = coord.x-pos.x;
	float diffY = coord.y-pos.y;
	
	vec3 tint = vec3(1.0,1.0,1.3);
	vec3 color = vec3(multiplier / (diffX*diffX + diffY*diffY));
	

	color *= tint;
		
	return color;   
}

vec3 cube(vec3 origin, float size){
	vec3 color = vec3(0.0);
	
	color+= particle(origin + vec3(0.0,0.0,0.0));
	
	color+= particle(origin + vec3(size,0.0,0.0));
	color+= particle(origin + vec3(-size,0.0,0.0));
	color+= particle(origin + vec3(0.0,size,0.0));
	color+= particle(origin + vec3(0.0,-size,0.0));
	
	
	color+= particle(origin + vec3(0.0,0.0,size));
	
	color+= particle(origin + vec3(size,0.0,size));
	color+= particle(origin + vec3(-size,0.0,size));
	color+= particle(origin + vec3(0.0,size,size));
	color+= particle(origin + vec3(0.0,-size,size));
	
	
	color+= particle(origin + vec3(0.0,0.0,-size));
	
	color+= particle(origin + vec3(size,0.0,-size));
	color+= particle(origin + vec3(-size,0.0,-size));
	color+= particle(origin + vec3(0.0,size,-size));
	color+= particle(origin + vec3(0.0,-size,-size));
	
	
	color+= particle(origin + vec3(size,size,0.0));
	color+= particle(origin + vec3(-size,size,0.0));
	color+= particle(origin + vec3(-size,-size,0.0));
	color+= particle(origin + vec3(size,-size,0.0));
	
	
	color+= particle(origin + vec3(size,size,size));
	color+= particle(origin + vec3(-size,size,size));
	color+= particle(origin + vec3(-size,-size,size));
	color+= particle(origin + vec3(size,-size,size));
	
	color+= particle(origin + vec3(size,size,-size));
	color+= particle(origin + vec3(-size,size,-size));
	color+= particle(origin + vec3(-size,-size,-size));
	color+= particle(origin + vec3(size,-size,-size));
	
	return color;
}

void main( void ) {  
	// unormalize coordinates
	coord = gl_FragCoord.xy / resolution.y;
	// shift origin to center
	coord -= vec2((resolution.x/resolution.y)/2.0, 0.5);
	// axis from -1,1
	coord *= vec2(2);
	// axis from -1,1
	
	vec3 color = vec3(0.0);
	
	//scale = vec3(0.5);
	translation = vec3(0.0,0.0,0);
	color += cube(vec3(0.0, 0.0, (mouse.x - 0.5) ), 0.2);
	
	gl_FragColor = vec4(color, 1.0);
}