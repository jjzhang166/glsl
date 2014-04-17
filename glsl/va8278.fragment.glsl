#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 position;

float sdist( vec3 p, float d)
{
	return length(p)-d; // < magic
}

vec3 pnormal(vec3 p, float d) 
{
	float eps = 0.001;
	return normalize( vec3(
		sdist(p+vec3(eps,0,0),d) - sdist(p-vec3(eps,0,0),d),
		sdist(p+vec3(0,eps,0),d) - sdist(p-vec3(0,eps,0),d),
		sdist(p+vec3(0,0,eps),d) - sdist(p-vec3(0,0,eps),d)) );
}

mat3 rotationMatrix(vec3 axis, float angle)
{
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;
    
    return mat3(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c);
}


#define MAX_RAY_STEPS 32
void main( void ) {
	//Screenspace Position
	position 	= gl_FragCoord.xy / resolution.y;
	position.x 	= position.x - 1.;
	position.y 	= position.y - resolution.y / resolution.x;

	//float ls = 0.05; //level set zero point
	float ls = (1.0+sin(time)*cos(time))*0.03+0.1; //woo!
		
	//Caching these for messing with....
	vec4 color = vec4(0.0, 0.0, 0.0, 0.0);
	vec3 field = vec3(0.0); //should prolly make this 4d; 4d = more better
	
	//This transform series is confused...
	mat3 mat 	= rotationMatrix(vec3(1,0,0),(mouse.y-.5)*3.14) * rotationMatrix(vec3(0,1,0),-(mouse.x-.5)*3.14);
	vec3 raypos	= mat * vec3 (position.x, position.y, -1);
	vec3 raydir 	= mat * vec3(0,0,1); //sit still and rotate!
	//vec3 raydir 	= mat * normalize(vec3(0.5-mouse.x, 0.5-mouse.y, 1.0));	//spin around uncontrollably!
	
	//Ray stuff - it came from somewhere, who knows where it will go next?
	int iter = 0;
	
	
	float len = 0.0;
	float epsilon = 0.0;
	float stepsize = 1.0;
	float scale = (2.0 / max(resolution.x, resolution.y)) * 0.5;
	
	for(int i=0;i<MAX_RAY_STEPS;i++) {
        	iter++;
			
		float sphere = length(raypos)-ls;
			
		len += sphere * stepsize;
		
		if(sphere < epsilon)
		{
			float bound = 1.0-float(iter)/float(MAX_RAY_STEPS);
			vec3 normal = pnormal(raypos, ls);
			color.rgb = normal * bound;
			break;
		}
		
		
		vec3 fn = pnormal(epsilon-normalize(raypos*field.rgb), sphere)/sphere; // < also magic
		field += fn * 2.0;
		
		float wave = length(field*smoothstep(1.1, 2.0, (len/field + mod(field+(time*1.9), 1.0))));
		wave = wave * wave + wave; // shiny!
		
		epsilon = scale * len;
		raypos += sphere * raydir * stepsize;	
	        
		color.rgb += ((wave/sphere) * fn) * 0.005;	
	    }
	
	gl_FragColor = color;
}

// cbirke@gmail
