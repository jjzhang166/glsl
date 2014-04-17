#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float val = 0.1;
	float radius = 8.0;
	
	for(int n=0; n<2; n++)
	{
		vec2 localPos = resolution / 1.0;
		localPos.y = resolution.y/2.0*sin(time+float(n))/7.0+resolution.y/1.5+float(n)-radius*float(n)*2.0;
		localPos.y *= (cos(gl_FragCoord.x/350.0*(float(n)+1.0))/10.0);
		localPos.y += resolution.y/1.5 + float(n)*radius;
		localPos.x = gl_FragCoord.x;
		if(gl_FragCoord.y > localPos.y) {
			float dist = length(gl_FragCoord.y - localPos.y)/2.0;
			if(dist < radius*1.5) {
				val += dist/radius*(dist/4.0);
			}
		}
	}
	
	for(int n=0; n<2; n++)
	{
		vec2 localPos = resolution / 2.0;
		localPos.y = resolution.y/2.0*sin(time+float(n))/7.0+resolution.y/1.5+float(n)-radius*float(n)*2.0;
		localPos.y *= (sin(gl_FragCoord.x/350.0*(float(n)+1.0))/10.0);
		localPos.y += resolution.y/3.0 + float(n)*radius;
		localPos.x = gl_FragCoord.x;
		if(gl_FragCoord.y < localPos.y) {
			float dist = length(gl_FragCoord.y - localPos.y)/2.0;
			if(dist < radius*1.5)
				val += dist/radius*(dist/4.0);
		}
	}
	
	val += length(vec2(1.0,1.0) - vec2(gl_FragCoord.x/10.0,gl_FragCoord.y/5.0))/500.0;
	gl_FragColor = vec4(0.229*val,0.529*val,0.721*val,1.0);

}