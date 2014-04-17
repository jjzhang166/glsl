#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// 10 PRINT CHR$ (205.5 + RND (1)); : GOTO 10

// Shabby - the one line basic maze doin' the rounds in a frag shader, a very nice bit of creative coding 
// - Added border
// - scrolling
// - added some oldschool funk
void main( void ) 
{
	vec3 colour = vec3(0.22,0.18,0.61);
	float xtime=mod(floor(time*110.0),5700.0);
	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	float san=cos((time+2.0)*0.75)*0.95;
	float can=sin((time+2.0)*0.75)*01.95;
	if (xtime>4000.0)
		{
		pos-=vec2(0.5,0.5);
		vec2 npos=vec2(pos.x*san+pos.y*can,pos.y*san-pos.x*can);
		pos=npos+vec2(0.5,0.5);
		}
		
	if (xtime>3000.0)
		pos=mod(pos,0.5)*2.0;
	if (xtime>2000.0)
		{
		pos-=vec2(0.5,0.5);
		vec2 npos=vec2(pos.x*san+pos.y*can,pos.y*san-pos.x*can);
		pos=npos+vec2(0.5,0.5);
		}
	vec2 bpos=0.5-abs(pos-0.5);
	pos=(vec2(pos.x,max(0.0,floor((xtime/60.0)-26.0)*0.0335)+1.0-(pos.y+0.015)))*vec2(3.0,1.5);
	float or=(pos.x*1.0/0.05)+(floor(pos.y*1.0/0.05)*60.0);
	pos=mod(pos,0.05);
	float r=(floor((sin(cos((floor(or)))*12.0)+1.0)));
	pos.x=((1.0-r)*-pos.x)+(r*pos.x);
	if (min(bpos.y,bpos.x)<0.084 ||(xtime>or && (abs(r*0.05-pos.x-pos.y)<0.01)))	colour=vec3(0.47,0.43,0.83);
	gl_FragColor = vec4( colour, 1.0 );

}