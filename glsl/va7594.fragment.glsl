#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float getX(int n, vec2 resolution, float d, float time)
{
	return sin(time*float(n+1)/10.0)*d/float(n+1)*time/(time/2.0)+resolution.x/2.0;
}

float getY(int n, vec2 resolution, float d, float time)
{
	return cos(time*float(n+1)/10.0)*d/float(n+1)*time/(time/2.0)+resolution.y/2.0;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec3 color = vec3(0.0,0.0,0.0);
	float radius = resolution.x / 100.0;
	float d = resolution.x / 1.0;

	for(int n=0; n<30; n++) {
		float x = getX(n,resolution,d,time);
		float y = getY(n,resolution,d,time);
		float tx = getX(n,resolution,d,time-time/1.5);
		float ty = getY(n,resolution,d,time-time/1.5);
		float dist = length(gl_FragCoord.xy-vec2(x,y));
		float trace = length(gl_FragCoord.xy-vec2(tx,ty));
		trace = pow(trace,1.5);
		dist = max(trace,dist);
		float c = radius*float(n+1)/5.0 / pow(dist,0.99);
		color.b += c;
		color.r += pow(c,0.99);
		color.g += pow((color.r+color.g) / float(n+1),0.99);
	}
	
	//float dist = distance(position.xy,vec2(sin(time*x)/10.0+0.5,cos(time*y)/10.0+0.5)) * 10.0;
	//color += vec3(dist,dist,dist);
	float power = 2.5;
	gl_FragColor = vec4( pow(color.r,power), pow(color.g, power), pow(color.b, power), 1.0 );

}