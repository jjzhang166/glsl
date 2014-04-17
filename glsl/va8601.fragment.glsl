#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// simple shader just for chill out.

void main( void ) {

	vec2 uv = ( gl_FragCoord.xy / resolution.xy ) * 0.5 + 0.5 * sin(time)+0.5;

	vec3 c = vec3(0.0);
	
	c 	+= step(uv.x,0.25)+step(uv.x, 0.5)*0.5;
	c += step(uv.x, 0.75)*0.25;
	c += step(uv.x, 1.0)*(0.25*0.5);
	c.r += step(uv.y, 0.25)*0.25;
	c.g += step(uv.y, 0.5)*0.5;
	c.b += step(uv.y, 0.75)*0.75;
	c.r += step(uv.y, 1.0)*1.0;
	
	c.g += step(uv.x*uv.y, 0.5)*0.5;
	c.b += step(uv.y-uv.x,0.2)*0.2;
	
	c *= uv.x;
	c *= uv.y;
	
	c += smoothstep(uv.x, uv.y, 0.5)*c*c*uv.y*2.0;
	c += smoothstep(uv.y*uv.x, uv.x, 0.5)*c*c*sin(uv.y);
	
	c += step ( uv.x * uv.y , 0.5)*0.05;
	
	

	gl_FragColor = vec4( c, 1.0 );

}