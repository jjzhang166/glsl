#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159265358979323846264

//mattdesl - devmatt.wordpress.com - textured sphere by Matt DesLauriers

void main( void ) {	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
	position.x *= resolution.x / resolution.y;
	
	vec2 norm = 2.0 * gl_FragCoord.xy / resolution.xy - 1.0;
	norm.x *= resolution.x / resolution.y;
	
	float r = length(norm);
	float phi = atan(norm.y, norm.x);
	
	//spherize
	r = 2.0 * asin(r) / PI;
	
	//bulge a bit
	r = pow(r, -0.75);	// yarr, now it's an interdimensional grid
	
	//zoom in a bit
	//r /= 1.25;
	
	vec2 coord = vec2(r * cos(phi), r * sin(phi));
	coord = coord/2.0 + 0.5;

	
	//color += sin(coord.y) + cos(coord.y * 30.0);
	//color *= cos(coord.y*80.0);

	//color -= sin(coord.x*sin(coord.y*5.0)*9.0)*20.0;
	
	
//	color.rgb += 0.25*sin(coord.y*sin(coord.x*0.0)*9.0)*2.5;
//	color.rgb += 0.45*sin(coord.x*30.0*sin(coord.y*1.0));
	
	float rings = 1.0;
	
	coord.x += time*0.05-(mouse.x*.05);
	coord.y += sin(time*.35)*0.1-mouse.y*.05;
	
	float block = 100.0;
	rings += sin(coord.y*block)*10.0;
	rings *= sin(coord.x*block)*0.25;
	rings *= sin(coord.x*block);
	rings *= sin(coord.y*block);
	
	//assymetry
	rings -= sin(coord.y*block)*.5;
	//rings += sin(position.x*0.025)*100.0;
	
	rings += 0.05*sin(coord.x*25.0)*25.0 * sin(time*1.5);
	rings += 0.05*sin(coord.y*25.0)*25.0;
	
	//* sin(time*1.0)*2.0-1.;
	
	rings = clamp(rings, 0., 1.0);
	
	float len = length(position);
	
	vec3 color = mix(vec3(sin(time*2.23)+1.0,cos(time*2.34)+1.0,cos(time)+1.0), vec3(0.0,0.0,0.0), rings);
	

	color *= smoothstep(0.54, 0.495, len);
	
	
	gl_FragColor = vec4( color, 1.0 );

}