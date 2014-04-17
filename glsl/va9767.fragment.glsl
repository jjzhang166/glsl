#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 tex(vec2 position)
{
	// from http://glsl.heroku.com/e#8558.0
	float sum = 0.;
	float qsum = 0.;
	vec2 coords[100];
	for(int i=0;i<10;i++)
	{
		for(int j=0;j<10;j++)
		{
			coords[i*10+j]=vec2(i,j);
		}
	}
	for (float i = 0.; i < 100.; i++) {
		float x2=coords[int(i)].x*0.8;
		float y2=coords[int(i)].y*0.8;
		vec2 p = (fract(position-vec2(x2,y2))-vec2(.5));
		float a = atan(p.y,p.x);
		float r = length(p)*100.;
		float e = exp(-r*.5);
		sum += sin(r+a+time)*e;
		qsum += e;
	}
	
	float color = sum/qsum;
	return step( 0.25, vec3( color, color-.5, -color ) );
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy )*2.0-1.0;
	
	vec2 sp = mouse-0.5;
	
	vec2 move = vec2(0.2,0.6);

	vec2 uv = vec2(p.x/abs(p.y)+time*move.x,1./(abs(p.y))+time*move.y);
	
	vec3 color = tex(p);
	color *= vec3(pow(.5,0.75));
	
	gl_FragColor = vec4(color, 1.0 );

}