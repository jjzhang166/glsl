#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//one millionth shitty radar shader. yey.
//fork by tigrou.ind at gmail.com : no radar is really complete without targets :)

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.5,0.5);
	position.y *= resolution.y/resolution.x;
	
	float color;
	
	float dist =sqrt(position.x*position.x+position.y*position.y);
	
	if(dist>0.3) {
		gl_FragColor = vec4(1.1,1.,1.,1.);
	}
	if(dist>0.3025) {
		gl_FragColor = vec4(0.,0.,0.,1.);
	}
	if(dist<0.3) {
		float angle = mod(-time/4.+ atan(position.y, position.x)/6.283,1.0);
		float dots = 0.0;
		for(int i = 0 ; i < 5 ; i++)
		{
		  float ptdist = cos(float(i)*5.0)*0.1+0.15;	
		  vec2 pt = vec2(cos(float(i)*0.4+time*0.02),sin(float(i)*0.4+time*0.02))*ptdist;
		  dots = max(dots, 0.0008/distance(position.xy, pt.xy))*1.0;
		}
		color = pow(angle,8.0)*(rand(position.xy)*0.1+1.0);
		gl_FragColor = vec4(color*dots*2.0,color+(color*2.0+0.5)*dots,color*dots*2.0,1.0);
	}
}