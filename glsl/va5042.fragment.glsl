#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
	
const int counter = 0;


void main( void ) {
	
	vec2 position = ( gl_FragCoord.xy/resolution );
	position.x *= resolution.x/resolution.y;
	vec2 myMouse = vec2( mouse.x * resolution.x/resolution.y, mouse.y);
	
	float color = 0.0;
	
	float radius = .025;
	
	
	vec2 p = position;
	p.x -= myMouse.x;
	p.y -= myMouse.y;
	
//	vec2 lastp = texture2D(backbuffer, vec2(0.5,0.5)).rg;	
	
	float r = sqrt(dot(p,p));
	
	if( r < radius) {
		color = 1.0-r/radius;
		
	}
	
	vec3 b = vec3(0,0,0);//color); // sin(vec3(color)+vec3(time,time*0.1,time*0.01));
	
	b += texture2D(backbuffer, gl_FragCoord.xy / resolution.xy).rgb;
	b += color*(0.8+0.2*sin(vec3(time,time*0.1,time*0.01)));
	
	gl_FragColor = vec4( b, 0.0 );
	
	if (gl_FragCoord.x < 1.0)// && gl_FragCoord.y < 1.0 )
	{
		if (gl_FragCoord.y < 1.0)
			gl_FragColor = vec4(p.xy,0,0);
	}

}