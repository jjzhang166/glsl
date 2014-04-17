/* Following iQ live coding tutorial on writing a basic raytracer http://www.youtube.com/watch?v=9g8CdctxmeU   @blurspline 
  * ... this forked version mostly just scrunched up to fit in less space without obfuscating too much. @danbri */
#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse, resolution;


//some ugly clouds
//noise function lifted from that eye
//added modification so I have 3d noise
//and now with some ugly god rays
//++small changes

#ifdef GL_ES
precision mediump float;
#endif


mat2 m = mat2( 0.90,  0.110, -0.70,  1.00 );

float hash( float n )
{
    return fract(sin(n)*758.5453);
}

float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);
    //f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0 + p.z*800.0;
    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
		    mix(mix( hash(n+800.0), hash(n+801.0),f.x), mix( hash(n+857.0), hash(n+858.0),f.x),f.y),f.z);
    return res;
}

float fbm( vec3 p )
{
    float f = 0.0;
    f += 0.50000*noise( p ); p = p*2.02;
    f += 0.25000*noise( p ); p = p*2.03;
    f += 0.12500*noise( p ); p = p*2.01;
    f += 0.06250*noise( p ); p = p*2.04;
    f += 0.03125*noise( p );
    return f/0.984375;
}

float cloud(vec3 p)
{
	p+=fbm(vec3(p.x,p.y,0.0)*0.5)*2.25;
	
	float a =0.0;
	a+=fbm(p*3.0)*2.2-0.9;
	if (a<0.0) a=0.0;
	//a=a*a;
	return a;
}

vec3 f2(vec3 c)
{
	c+=hash(time+gl_FragCoord.x+gl_FragCoord.y*9.9)*0.01;
	
	
	c*=0.7-length(gl_FragCoord.xy / resolution.xy -0.5)*0.7;
	float w=length(c);
	c=mix(c*vec3(1.0,1.2,1.6),vec3(w,w,w)*vec3(1.4,1.2,1.0),w*1.1-0.2);
	return c;
}

void mainxx( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;
	position.y+=0.2;

	vec2 coord= vec2((position.x-0.5)/position.y,1.0/(position.y+0.2))+mouse*vec2(-0.5,0.5);
	
	
	
	//coord+=fbm(vec3(coord*18.0,time*0.001))*0.07;
	coord+=time*0.01;
	
	
	float q = cloud(vec3(coord*1.0,time*0.0222));

	
	

vec3 	col =vec3(0.5,0.5,0.6) + vec3(q*vec3(0.9,0.9,0.9));
	gl_FragColor = vec4( f2(col), 1.0 );

}


vec3 nSphere( in vec3 pos, in vec4 sph ) { return ( pos - sph.xyz ) / sph.w; }  // normals(?)
vec3 nPlane( in vec3 pos ) {	return vec3 (0.0, 1.0, 0.0); }
vec4 sph1 = vec4( 0.0, 1.0, 0.0, 1.0); // sphere, w is size
float iPlane( in vec3 ro, in vec3 rd ) { return -ro.y / rd.y; } // intersections
float iSphere( in vec3 ro, in vec3 rd, in vec4 sph ) {
	vec3 oc = ro - sph.xyz; // looks like we are going place sphere from an offset from ray origin, which is = camera
	float b = 2.0 * dot( oc, rd );
	float c = dot(oc, oc) - sph.w * sph.w; // w should be size
	float h = b*b - 4.0 *c;
	if (h<0.0) { return -1.0; }
	float t = (-b - sqrt(h)) / 2.0;
	return t;
}
float intersect( in vec3 ro, in vec3 rd, out float resT ) {
	resT = 1000.;
	float id = -1.0;
	float tmin = -1.0;
	float tsph = iSphere( ro, rd, sph1 ); 
	float tpla = iPlane( ro, rd ); 
	if ( tsph>0.0 ) {
		resT = tsph;
		id = 1.0;
	}
	if (tpla > 0.0 && tpla <resT ) {
		id = 2.0;
		resT = tpla;
	}	
	return id;
}
void main( void ) {
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;
	float q = cloud(vec3(position,time*0.15));
	vec3 skycol =vec3(0.35,0.4,0.7) + vec3(q*vec3(0.8,0.8,0.8));
	
	vec3 light = normalize( vec3(0.5,0.6,0.4) );	// ok, here we come, GLSL raytacing!
	vec2 uv = ( gl_FragCoord.xy / resolution.xy );  // this is the pixel coords
	sph1.xz = vec2 ( 0.1 * cos( time ),  2.0 * sin( time )); // move sphere around	
	vec3 ro = vec3( .1, 0.2, 3.0 ); //ray origin
	vec3 rd = normalize( vec3( -1.0 + 2.*uv* vec2(resolution.x/resolution.y, 1.0), -1.0 ) ); // ray destination
	float t;
	float id = intersect( ro, rd, t ); 		// we intersect ray with 3d scene
	vec3 col = skycol;//vec3(0.3);
	if ( id>0.5 && id<1.5 ) {			// sphere		
		vec3 pos = ro + t * rd;
		vec3 nor = nSphere( pos, sph1 );
		float dif = clamp( dot( nor, light ), 0.0, 1.0); // diffuse light
		float ao = 0.2 + 0.5 * nor.y;
		col = vec3( 0.8, 0.8, 0.6) * dif * ao + vec3(0.1, 0.2, 0.4) * ao;
	} else if ( id>1.5 ) {				// plane
		vec3 pos = ro + t * rd;
		vec3 nor = nPlane( pos );
		float dif = clamp( dot(nor, light), 0.0, 1.0 );
		float amb = smoothstep( 0.0, sph1.w * 2.0, length(pos.xz - sph1.xz) ); // shadows under the sphere
		col = vec3 (amb * 0.8);
	}		
	gl_FragColor = vec4( sqrt(col), 1.0 );
}