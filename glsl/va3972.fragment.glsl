/**
Change log:
- First version of fake 3D space
- Unormalize space and coordinates
- shift origin to center
**/

#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float glitch;
mat2 m = mat2( 0.80,  0.60, -0.60,  0.9 );

float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
    return res;
}

float fbm( vec2 p )
{
    float f = 0.0;
    f += 0.50000*noise( p ); p = m*p*2.02;
    f += 0.25000*noise( p ); p = m*p*2.03;
    f += 0.12500*noise( p ); p = m*p*2.01;
    f += 0.06250*noise( p ); p = m*p*2.04;
    f += 0.03125*noise( p );
    return f/0.984375;
}

vec3 particle(vec2 coord, vec3 pos){
	// unormalize space
	pos.x *= resolution.x/resolution.y;
	pos.x *= resolution.y/resolution.x;
	
	// use 'z' to fake the position and size
	float depth = pos.z + 1.0;
	pos.xy *= depth;
	float multiplier = 0.001 * depth;
	
	float diffX = coord.x-pos.x;
	float diffY = coord.y-pos.y;
	
	vec3 tint = vec3(1.0,1.0,1.3);
	vec3 color = vec3(multiplier / (diffX*diffX + diffY*diffY));
	
	color *= tint;
		
	return color;   
}

vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

vec3 cube(vec2 coord, vec3 o){
	float t = time*(glitch/20.0+1.);
	vec3 colors[3];
	for (float i = 0.; i < 3.; i++) {
	vec3 color = vec3(0.0);
	vec3 origin = o;
	vec3 offset = vec3(fbm(vec2(t, i*0.0)), fbm(vec2(t, i*1.0)), fbm(vec2(t, i*2.0))) * 0.1;
	origin += offset -.05;
		
	origin.x += color+= particle(coord, origin + vec3(0.0,0.0,0.0));;
	
	color+= particle(coord, origin + vec3(0.5,0.0,0.0));
	color+= particle(coord, origin + vec3(-0.5,0.0,0.0));
	color+= particle(coord, origin + vec3(0.0,0.5,0.0));
	color+= particle(coord, origin + vec3(0.0,-0.5,0.0));
	
	color+= particle(coord, origin + vec3(0.5,0.0,0.5));
	color+= particle(coord, origin + vec3(-0.5,0.0,0.5));
	color+= particle(coord, origin + vec3(0.0,0.5,0.5));
	color+= particle(coord, origin + vec3(0.0,-0.5,0.5));
	
	offset = vec3(fbm(vec2(t, i*3.0)), fbm(vec2(t, i*4.0)), fbm(vec2(t, i*5.0))) * 0.1;
	origin -= offset -.05;
	
	color+= particle(coord, origin + vec3(0.5,0.0,-0.5));
	color+= particle(coord, origin + vec3(-0.5,0.0,-0.5));
	color+= particle(coord, origin + vec3(0.0,0.5,-0.5));
	color+= particle(coord, origin + vec3(0.0,-0.5,-0.5));
	
	color+= particle(coord, origin + vec3(0.5,0.5,0.0));
	color+= particle(coord, origin + vec3(-0.5,0.5,0.0));
	color+= particle(coord, origin + vec3(-0.5,-0.5,0.0));
	color+= particle(coord, origin + vec3(0.5,-0.5,0.0));
	
	offset = vec3(fbm(vec2(t, i*6.0)), fbm(vec2(t, i*7.0)), fbm(vec2(t, i*8.0))) * 0.1;
	origin += offset -.05;
	
	color+= particle(coord, origin + vec3(0.5,0.5,0.5));
	color+= particle(coord, origin + vec3(-0.5,0.5,0.5));
	color+= particle(coord, origin + vec3(-0.5,-0.5,0.5));
	color+= particle(coord, origin + vec3(0.5,-0.5,0.5));
	
	color+= particle(coord, origin + vec3(0.5,0.5,-0.5));
	color+= particle(coord, origin + vec3(-0.5,0.5,-0.5));
	color+= particle(coord, origin + vec3(-0.5,-0.5,-0.5));
	color+= particle(coord, origin + vec3(0.5,-0.5,-0.5));
	
	if(i==0.0) colors[int(i)] = color * vec3(1,0,0);
	if(i==1.0) colors[int(i)] = color * vec3(0,1,0);
	if(i==2.0) colors[int(i)] = color * vec3(0,0,1);
	colors[int(i)] = mix(color, colors[int(i)], glitch - 0.2);
	}

	vec3 color = colors[0] + colors[1] + colors[2];
		
	return color / 3.0;
}

void main( void ) {  
	// unormalize coordinates
	vec2 coord = ( gl_FragCoord.xy / resolution.y );
	// shift origin to center
	coord -= vec2((resolution.x/resolution.y)/2.0, 0.5);
	// axis from -1,1
	coord *= vec2(2);
	// axis from -1,1
	
	vec3 color = vec3(0.0);
	glitch = pow(2.1, pow(500.0, fbm(vec2(time * 2.0)) * 2.0 - 1.0) / 40.0 * fbm(vec2(gl_FragCoord.y / 5.0, time*200.0)));
	coord.x /= glitch;
	color += cube(coord, vec3(0.0));
	
	gl_FragColor = vec4(color, 1.0);
}