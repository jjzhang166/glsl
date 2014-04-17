/*****************\
| 		  |
| USA IS DOMINATE |
|		  |
\*****************/


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159
#define ST 0.03846153846

vec2 rotate(vec2 p,float angle){
   vec2 q;
   q.x =p.x*cos(angle)-p.y*sin(angle);
   q.y =p.x*sin(angle)+p.y*cos(angle);
   return q;
}

float rect(vec2 p, vec2 s ){
	if(length(max(abs(p)-s,0.0))==0.){
		return 1.;
	}
	return 0.;
}

//i stole this sorry :<
float star(vec2 p,float r) {
	p=rotate(p,PI/2.);

	vec2 p0 = rotate(p, radians(36.0));
	vec2 p1 = rotate(p, radians(108.0));
	vec2 p2 = rotate(p, radians(180.0));
	vec2 p3 = rotate(p, radians(252.0));
	vec2 p4 = rotate(p, radians(324.0));
	
	float j = 0.;
	
	if(p0.x > r) j++;
	if(p1.x > r) j++;
	if(p2.x > r) j++;
	if(p3.x > r) j++;
	if(p4.x > r) j++;

	return (j <=1.) ? 1. : 0.;
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.y );
	vec2 m=mouse;
	m.x*=resolution.x/resolution.y;
	vec3 col;
	
	//do stripes, than blue, than stars
	//first 7
	col.r+=rect(pos-vec2(1.6,25.*ST),vec2(1.,ST));
	col+=rect(pos-vec2(1.6,23.*ST),vec2(1.,ST));
	col.r+=rect(pos-vec2(1.6,21.*ST),vec2(1.,ST));
	col+=rect(pos-vec2(1.6,19.*ST),vec2(1.,ST));
	col.r+=rect(pos-vec2(1.6,17.*ST),vec2(1.,ST));
	col+=rect(pos-vec2(1.6,15.*ST),vec2(1.,ST));
	col.r+=rect(pos-vec2(1.6,13.*ST),vec2(1.,ST));
	
	//last 6
	col+=rect(pos-vec2(1.,11.*ST),vec2(1.,ST));
	col.r+=rect(pos-vec2(1.,9.*ST),vec2(1.,ST));
	col+=rect(pos-vec2(1.,7.*ST),vec2(1.,ST));
	col.r+=rect(pos-vec2(1.,5.*ST),vec2(1.,ST));
	col+=rect(pos-vec2(1.,3.*ST),vec2(1.,ST));
	col.r+=rect(pos-vec2(1.,1.*ST),vec2(1.,ST));
	
	col.b+=rect(pos-vec2(0.3,19.*ST),vec2(0.3,7.*ST));

	//5 by 6 then a 4 by 5
	for(float i=0.;i<5.;i++){
		for(float j=0.;j<6.;j++){
			col+=star(pos-vec2(j/10.,i/10.)-vec2(0.045,0.53),0.01);
		}
	}
	
	for(float i=0.;i<4.;i++){
		for(float j=0.;j<5.;j++){
			col+=star(pos-vec2(j/10.,i/10.)-vec2(0.095,0.58),0.01);
		}
	}
	
	
	gl_FragColor = vec4(col, 1.0 );

}