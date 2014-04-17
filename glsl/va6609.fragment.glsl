#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//VGA Colors

#define BLACK vec3(0.0)
#define DARKGREY vec3(0.5)

#define DARKRED vec3(0.5,0.0,0.0)
#define RED vec3(1.0,0.0,0.0)

#define DARKGREEN vec3(0.0,0.5,0.0)
#define GREEN vec3(0.0,1.0,0.0)

#define DARKYELLOW vec3(0.5,0.5,0.0)
#define YELLOW vec3(1.0,1.0,0.0)

#define DARKBLUE vec3(0.0,0.0,0.5)
#define BLUE vec3(0.0,0.0,1.0)

#define DARKPINK vec3(0.5,0.0,0.5)
#define PINK vec3(1.0,0.0,1.0)

#define DARKCYAN vec3(0.0,0.5,0.5)
#define CYAN vec3(0.0,1.0,1.0)

#define LIGHTGREY vec3(0.753)
#define WHITE vec3(1.0)

vec3 vga[16];

vec3 closestColor(vec3 c)
{
	vga[0] = BLACK;
	vga[1] = DARKGREY;
	vga[2] = DARKRED;
	vga[3] = RED;
	vga[4] = DARKGREEN;
	vga[5] = GREEN;
	vga[6] = DARKYELLOW;
	vga[7] = YELLOW;
	vga[8] = DARKBLUE;
	vga[9] = BLUE;
	vga[10] = DARKPINK;
	vga[11] = PINK;
	vga[12] = DARKCYAN;
	vga[13] = CYAN;
	vga[14] = LIGHTGREY;
	vga[15] = WHITE;
	
	float dist = 1.0;
	int idx = 0;
	for (int i=0; i<16; i++) 
	{
		float tdist = distance(c,vga[i]);
		if(tdist < dist)
		{
			dist = tdist;
			idx = i;
		}
  	}
	for (int i=0; i<16; i++) 
	{
		if(i == idx)
		{
			return vga[i];
		}
  	}
	return vec3(0.0);
	
}

vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

void main( void ) 
{
		
	vec2 p = ( gl_FragCoord.xy )/resolution;

	vec3 color = vec3(0.0);
	
	color = hsv2rgb(p.x,1.0,1.0);
	color = closestColor(color);
		
	gl_FragColor = vec4( color , 1.0 );

}