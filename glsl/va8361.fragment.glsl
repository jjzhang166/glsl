#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 resolution;
uniform float time;
#define ST 0.10

float rect(vec2 p, vec2 s ){
if(length(max(abs(p)-s+.002*sin(time*5.0),0.0))==0.0){
return 0.7;
}
return 0.0;
}
void main( void ) {
	vec2 pos = ( gl_FragCoord.xy / resolution.y );
	vec3 col;
	col.r+=rect(pos-vec2(1.,9.*ST),vec2(1.,ST));
	col.r+=rect(pos-vec2(1.,7.*ST),vec2(1.,ST));
	col+=rect(pos-vec2(1.0,7.*ST),vec2(0.4,ST));
	col.r+=rect(pos-vec2(1.,5.*ST),vec2(1.,ST));
	col.r+=rect(pos-vec2(1.,3.*ST),vec2(1.,ST));
	col+=rect(pos-vec2(1.0,3.*ST),vec2(0.4,ST));
	col.r+=rect(pos-vec2(1.,1.*ST),vec2(1.,ST));
	
	float x = 0.6 + 0.2 * sin(5.0* time);
	float y = 0.5; 
	float b = 0.0;
	
	b += rect(pos-vec2(x,y), vec2(0.3, 0.09));
	if( length(pos - (vec2(x,y) - vec2(0.3,0.1))) < 0.1) {
		b += 0.75; 
	}
	
	if( length(pos - (vec2(x,y) - vec2(0.3,-0.1))) < 0.1) {
		b += 0.75; 
	}
	if( length(pos - (vec2(x,y) - vec2(-0.3,0.0))) < 0.1) {
		b += 1.0; 
	}
	
	if( rect(pos-vec2(x+.42,y), vec2(0.1, 0.01)) == 0.0 )
	  col.gb += clamp( b, 0.0, 0.75); 
	
	for(float i=0.;i<2.;i++){
		for(float j=0.;j<6.;j++){
			col+=0.;
		}
	}
gl_FragColor = vec4(col, 1.0 );
}