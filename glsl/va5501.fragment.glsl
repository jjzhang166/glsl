#ifdef GL_ES
precision mediump float;
#endif

//simple noise generation explorer
//gravityloss.com

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.y ) + mouse / 4.0;
	
//	float color = 0.5+0.5*sin(mod(position.x*1601.,17.));
	
//	float color = 0.5+0.5*sin(mod(length(position)*81234258.,6.28));

//	float color = 0.5+0.5*(mod(length(position)*81234258.,0.9));

//	float color = fract((position.x*122231.2323+position.y*1143435.3432));
//	float color = sin(fract(position.x*2234549+(gl_FragCoord.x)));//+fract(position.y*323456.);

//	float color = 0.5+0.5*sin(mod(gl_FragCoord.x*resolution.x*2323.42,2141.2));

	
//	float color = mod(fract(position.x*resolution.x*resolution.x),0.1); //pretty nice

	float r,g,b;
	
	//pretty nice multicoloured
//	r = fract(length(position)*1232425.);
//	g = fract(r*1.2);
//	b = fract(g*2.1);


	//kaakelit
//	r = fract(dot(position,position)*123242.);
//	g = fract(r*1.2);
//	b = fract(g*2.1);

//kernels
//	r = fract(position.x*position.y*585555.);
//	g = fract(r*1.25);
//	b = fract(g*1.25);

	//resolution explorer
//	r = fract(position.x*position.y*100.*mouse.x*resolution.x);
//	g = fract(r*2.);
//	b = fract(g*2.);


	r = fract(gl_FragCoord.x*gl_FragCoord.y*1.*pow(mouse.x*10.,4.));
	g = fract(r*2.);
	b = fract(g*2.);

	
	//float color = fract(fract((position.x*(resolution.x+14.434)))*421.);

//	color=0.3*color+0.3;
	
//	gl_FragColor = vec4( color,color,color,0.0);
	
	gl_FragColor = vec4(r,g,b,0.0);

}