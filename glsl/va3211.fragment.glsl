// by rotwang
//oh rly?
// yes, I am putting some clear written snippets here for beginners
// do you have a problem with helping people?
// I'am tagging my snippets, so I can find and approve them
// Do you have a problem with this?
// Just stay in your kindergarten

//just bad form to copy a shader from two or three before yours and slap your tag on it. No worries, whatever floats your boat.

// rotwang:
// You really have a reality problem.
// every single line here was written by me
// as can clearly seen by my writing style with unipos, apos, sint etc...

// whenever I modify an original, you will see the following tags:
// @mod+ added something
// @mod- removed something
// @mod* changed something

// Example:
// Some hills...
// rotwang: @mod* lowered cam for better flight feeling
// @mod+ mouse y controls flight height
// @mod* some color tests
// @mod+ Canyon
// @emackey: Simple sky blue (no clouds...)
// @rotwang: mod* sky gradient, different terrain front and backcolor
// @mod* stripes texture


#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;


void main( void ) {
   
	vec2 unipos = gl_FragCoord.xy / resolution;
	vec2 pos = unipos *2.0-1.0;
	vec2 apos = abs(pos);
	
	float xdiv = 4.0;
	float ydiv = 2.0;
	float a = mod(unipos.x,1.0/xdiv)*xdiv;
	float b = mod(unipos.y,1.0/ydiv)*ydiv;
	
	float c = smoothstep(a*2.5, a*0.1 , b*2.0);
	vec3 clr = vec3(pow(c*a,b));
    gl_FragColor = vec4(clr, 1.0);
}