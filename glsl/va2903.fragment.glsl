#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += .3*sin(position.x*4.+time+mouse.x);
	float color2 = 1.-  mix(distance(color + .7 , position.y)*20., abs(2.*sin(position.x+abs(time)-.3)), 600.*time);
	color2 = 1.-  mix(distance(color + .7 , position.y)*20., abs(log(tan(position.x+abs(time)-.3))/log(cos(time)*sin(time))), 600.*time*5.);

	gl_FragColor = vec4( vec3( cos(color2)+ .3*color2 - sin(time*3.), tan(color2) - sin(time*3.)+position.x, mix(1.,tan(.2*time+color2)-.3*tan(.2*time-color2), position.x)), 1.0 );

}