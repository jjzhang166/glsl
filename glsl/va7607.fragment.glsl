#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec3 color = vec3(0.0,0.0,0.0);
	float radius = resolution.x / 1000.0;
	float d = resolution.x / 1.0;

	for(int n=0; n<140; n++) {
		float x = sin(time*float(n+1)/10.0)*d/float(n+1)*time/(time/2.0)+resolution.x/2.0;
		float y = cos(time*float(n+1)/10.0)*d/float(n+1)*time/(time/2.0)+resolution.y/2.0;
		float dist = length(gl_FragCoord.xy-vec2(x,y));
		float c = radius*float(n+1)/5.0 / pow(dist,2.0);
		color.b += c;
		color.r += c;
		color.g += (color.r+color.g) / float(n+1);
	}
	
//	float dist = distance(position.xy,vec2(sin(time*x)/10.0+0.5,cos(time*y)/10.0+0.5)) * 10.0;
//	color += vec3(dist,dist,dist);
	gl_FragColor = vec4( color, 1.0 );

}