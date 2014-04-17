// @thevaw

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float col(float dist, float side) {
	if(side==0.0)
		return 0.0+dist*7.0;
	else
		return 0.5+(1.0-dist)*5.0;
}

void main( void ) {

       vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

       float color = 0.0;
	float mysin=sin(position.y*2.0+time+sin(position.y*1.0+time*1.0)*2.0);
	float mysin2=sin(position.y*2.0+time);
	float start=0.4+mysin*0.04+0.02;
	float end=0.6+mysin*0.04+0.02;
	float side=0.0;

	float size=(end-start)/1.0;
	float middle=mysin*size+size+start;

	float dist=middle-start;


	if(middle>end) {
		middle-=size;
		side=1.0;
		//dist-=middle;
	}



	if(position.x>start && position.x<end)
		if(position.x<middle)
			color=col(dist, side);
		else
			color=col(dist, mod( side+1.0, 2.0));



       gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}