precision mediump float;
//Ray marching is for noobs
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct Ray {
   vec3 Origin;
   vec3 Dir;
};
    
struct AABB {
   vec3 Min;
   vec3 Max;
};

vec3 rayDirection = vec3(gl_FragCoord.xy / resolution.xy, 0); 
vec3 origin = vec3(-1);


float tnear, tfar;



bool IntersectBox(Ray r, AABB aabb, out float t0, out float t1)
{
vec3 invR=1.0/r.Dir; 
	vec3 tbot = invR  * (aabb.Min-r.Origin);
	vec3 ttop = invR * (aabb.Max-r.Origin);
	vec3 tmin = min(ttop, tbot);
	vec3 tmax = max(ttop, tbot);
	vec2 t = max(tmin.xx, tmin.yz);
	t0 = max(t.x, t.y);
	t = min(tmax.xx, tmax.yz);
	t1 = min(t.x, t.y);
	return t0 <= t1;
}
float zfar,znear;
vec3 vCamPos = vec3(1.4+cos(time*.1),1.5+sin(time),1.5);
void main( void ) {

	vec2 vPos = gl_FragCoord.xy / resolution.xy;
	vec2 vViewPlane = ((vPos * 2.0) - 1.0) / vec2(1.0, resolution.x / resolution.y);
	vec3 vForwards = -normalize(vec3(0.0, 0.0, 0.0) - vCamPos);
	vec3 vRight = normalize(cross(vForwards, vec3(0, 1, 0)));
	vec3 vUp = cross(vRight, vForwards);

	vec3 vRayDir = normalize((-vRight * vViewPlane.x) + (vUp * vViewPlane.y) + vForwards);
	vec3 vRayPos = vCamPos;


Ray eye = Ray( vRayPos, (vRayDir) );

	
   if ( IntersectBox(eye, AABB(vec3(0.0), vec3(1.1,1.3,1.1) ), znear,zfar) )
   {
	   if ( IntersectBox(eye, AABB(vec3(0.,0.,0.0), vec3(0.3,0.5,0.1) ), znear,zfar) ){
		gl_FragColor = vec4( (vRayPos.xyz+vRayDir), 1 );
	   }
	   if ( IntersectBox(eye, AABB(vec3(0.7,0.3,0.0), vec3(0.8,.6,0.7) ), znear,zfar) ){
		gl_FragColor = vec4( (vRayPos.xyz+vRayDir), 1 );
	   }
	   if ( IntersectBox(eye, AABB(vec3(0.7,0.1,0.0), vec3(0.8,0.2,0.1) ), znear,zfar) ){
		gl_FragColor = vec4( (vRayPos.xyz+vRayDir), 1 );
	   }
	   if ( IntersectBox(eye, AABB(vec3(.7,0.9,0.0), vec3(0.8,0.8,0.7) ), znear,zfar) ){
		   	   if ( IntersectBox(eye, AABB(vec3(.75,0.95,0.0), vec3(0.85,0.85,0.7) ), znear,zfar) ){
		gl_FragColor = vec4( (vRayPos.xyz+vRayDir), 1 );
			   }else{
		discard;
			   }
	   }
	   

	   
   }else{
	   discard;
   }
}