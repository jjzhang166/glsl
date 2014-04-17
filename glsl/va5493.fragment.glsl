#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

//	vec2 spos = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	vec3 cpos = vec3(0.0,0.0,0.0);
	
	//vec3 sray = vec3((mouse-0.5)*2.,0.1);
	//vec3 cdir = normalize(sray);
	
	vec2 eul=vec2(sin(3.14*(mouse.x-0.5)),sin(3.14*(mouse.y-0.5)));
	vec3 sray = vec3(eul,sqrt(1.0-length(eul)));
	vec3 cdir=sray;
	
	
//	mat3 rotmat = mat3(vec3(cdir.x,cdir.y,0.0),vec3(cdir.y,cdir.x,0.0),vec3(0.0,0.0,1.0));

//	mat3 rotmat = mat3(vec3(cdir.x,-cdir.y,0.0),vec3(cdir.y,cdir.x,0.0),vec3(0.0,0.0,-cdir.z));
//	mat3 rotmat = mat3(vec3(1.0,0.0,0.0),vec3(-cdir.z,cdir.x,cdir.y),vec3(0.0,0.0,0.0));
//	mat3 rotmat = mat3(vec3(-cdir.x,0.0,0.0),vec3(cdir.y,-cdir.y,cdir.z),vec3(0.0,cdir.z,cdir.y));

	mat3 rotmat = mat3(vec3(cdir.z,0.0,-cdir.x),vec3(0.0,cdir.z,-cdir.y),vec3(0.0,0.0,0.0));
	
	//vec3 spos = sray+vec3(gl_FragCoord.x-resolution.x+resolution.y,gl_FragCoord.y,0.0)/resolution.y;
	
	vec3 spos = sray+rotmat*(vec3(gl_FragCoord.x-resolution.x+resolution.y,gl_FragCoord.y,0.0)/resolution.y);
		
//	vec3 cpos = vec3(0,0.0,0.0);
//	vec3 spos = vec3(mouse*1.+vec2(gl_FragCoord.x+gl_FragCoord.x-gl_FragCoord.y,gl_FragCoord.y),gl_FragCoord.y)/resolution.y;
	
	vec3 vray = cpos-spos;

	//flat plane
	float gy=-10.; 
	float d = spos.y-gy/vray.y;
	
	
	
	float color = 0.0;
	float bcolor = 0.1;
	
	if (d>1. && d<100000.0)
	{
		vec3 gpos = d * vray;
		color = floor(mod(0.01*gpos.x,1.05))+floor(mod(0.2*gpos.z,1.05));	
		bcolor = mod(length(gpos.xz),10.);
	}
	
	if(distance(gl_FragCoord.xy,resolution.xy)<100.5)
	{
		color = eul.x+1.0;
		bcolor = color;
	}
	if(distance(resolution.xy-gl_FragCoord.xy,resolution.xy)<100.5)
	{
		color = eul.y+1.0;//length(vray/10.);
		bcolor = color;
	}
	
	gl_FragColor = vec4( vec3( color*4., color, bcolor ), 1.0 );

}