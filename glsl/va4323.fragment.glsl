#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{
	vec2 p=gl_FragCoord.xy/resolution.y;
	float sphere;
	p.x -= (resolution.x / resolution.y) * 0.5;
	p.y -= 0.5;
	p*=5.0;
	sphere = sqrt(mouse.x*mouse.x-p.x*p.x-p.y*p.y);
//	if ( sqrt(p.x)
	if (sqrt(p.x*p.x+p.y*p.y) <= mouse.x)
	 	gl_FragColor=vec4(sphere,sphere,sphere,1.0);
	
}