#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi=3.1415926535;

float wave(vec2 pos,float angle,float wavelength,float phase,int i)
{
	return sin(dot(pos,vec2(cos(angle),sin(angle)))*2.0*pi/wavelength+phase+float(i));
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 m = (gl_FragCoord.xy / resolution.xy - mouse);
	vec2 n = (gl_FragCoord.xy / resolution.xy - vec2(0.5,0.5));
	float dist = (m.x * m.x + m.y * m.y);
	float dist2 = n.x * n.x + n.y * n.y;
	
	float luminance = dist*1.0+1.0/(1.0+sin(mouse.x));
	
	float red = sin( position.y * sin( luminance / 1.0 ) * 40.0 ) + cos( position.x * sin( luminance / 1.0 ) * 40.0 *time );
	red += sin( position.x * acos( luminance / 1.0 ) * 1.0 ) + cos( position.y * cos( luminance / 1.0 ) * 1.0);
	
	float green = wave(position,atan(abs(position.y-mouse.y)/abs(position.x-mouse.x)) , 0.1, time * 5.0, 0);
	green += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	
	float blue = 1.0 - dist2;
	

	gl_FragColor = vec4(red*red*dist, 0.2*red + 5.8*green*dist*mouse.x, (red*luminance + 2.0*dist2*green), 1.0 );
	//gl_FragColor = vec4(1.0, 1.0, blue, 1.0 );

}