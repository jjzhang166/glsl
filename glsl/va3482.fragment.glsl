#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( (gl_FragCoord.xy - resolution.xy*0.5) / resolution.x );
	vec2 center1 = vec2(sin(time), sin(time*0.535))*0.3;
	vec2 center2 = vec2(sin(time*0.259), sin(time*0.605))*0.4;
	vec2 center3 = vec2(sin(time*0.346), sin(time*0.263))*0.3;
	float size = (sin(time*0.1)+1.2)*20.;
	vec3 color = vec3(0.);
	if(fract(distance(position, center1)*size)>0.5) {
		color += vec3(1.,1.0,0.0);
	}
	if(fract(distance(position, center2)*size)>0.5) {
		color = abs(color-vec3(0.,1.,1.));
	}
	if(fract(distance(position, center3)*size)>0.5) {
		color -= vec3(1.,1.,1.);
	}
	
	gl_FragColor = vec4( abs(color), 1.0 );

}