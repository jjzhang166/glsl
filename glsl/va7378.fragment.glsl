//GLSL adaptation of rock paper scissors cellular automaton by JRM


#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;


float rand(vec2 co){
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

int color(vec4 col){
	if(col.r == 0.0 && col.g == 0.0 && col.b == 0.0)
		return 0;
	if(max(col.r,max(col.g,col.b))==col.r && col.r > 0.5)
		return 1;
	if(max(col.r,max(col.g,col.b))==col.g && col.g > 0.5)
		return 2;
	if(max(col.r,max(col.g,col.b))==col.b && col.b > 0.5)
		return 3;
	return 4;
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec4 me = texture2D(backbuffer, position);


	float mradius = 0.01;//0.07 * (-0.03 + length(zoomcenter - mouse));
	if (mouse.y>0.1 && length(position-mouse) < 0.01) {
		float rnum = (position.x+position.y)/2.0;
		if(rnum < 0.33)
			me = vec4(1.0,0.0,0.0,1.0);
		
		else if(rnum<0.66)
			me = vec4(0.0,1.0,0.0,1.0);
		
		else
			me = vec4(0.0,0.0,1.0,1.0);
		gl_FragColor = me;
	} else {
		vec4 source = texture2D(backbuffer, position + vec2((rand(vec2(time+position*30.0))-.5)/resolution.x,(rand(vec2(time+position*40.0))-.5)/resolution.y)*6.9);
		
		//me = me * 0.05 + source * 0.95;
		if(color(me)==1 && color(source) == 2)
			me = source;
		else if(color(me)==2 && color(source) == 3)
			me = source;
		else if(color(me)==3 && color(source) == 1)
			me = source;
			else if(max(me.b,max(me.r,me.g)) < 0.5 /* && rand(position*0.001+time*0.01)<0.1 */){
				if(source.r > 0.6 || source.g > 0.6 || source.b > 0.6)
				me = me + 0.2*source;
			}
		if(mouse.y>0.9)
			me = me + source*.01;
		//me = vec4(0.0);
	}
	if(mouse.x < 0.1)
		me = vec4(rand(position*0.001+time*0.01+0.5),rand(position*0.001+time+0.0123),rand(position*0.001+time*0.001+0.272),1.0);
	if(mouse.x > 0.9)
		me = vec4(0.0);
	gl_FragColor = me;
}
