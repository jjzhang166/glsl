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


void main( void ) {
	
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
	
	vec2 p = ( gl_FragCoord.xy );

	vec3 color = vec3(0.0);
	
	float c = mod(p.y+p.x,2.0);
	
	int idx = int(mod(p.x*0.0625,17.0));
	
	for (int i=0; i<16; i++) 
	{
     		if (i==idx) 
		{
        		color = vga[i];
        		break;
     		}
  	}
	

	gl_FragColor = vec4( color , 1.0 );

}