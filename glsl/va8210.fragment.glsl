#ifdef GL_ES
precision mediump float;
#endif

//Ashok Gowtham M
//https://github.com/ashokgowtham


//The secret valley
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );

	vec4 col;
		
	col.r=1.;
	col.g = max(sin(-mouse.x*10.+pos.x*100.),sin(-mouse.y*10.+pos.y*100.));
	
	gl_FragColor = mix(col,texture2D(bb,pos),( pow(abs(pos.y-.5),.12)*pow(abs(pos.x-.5),.12)*1.3*.75+.25));
}