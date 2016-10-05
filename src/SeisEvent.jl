import Base:summary, show

"""
    S = SeisHdr()

Create a seismic header. Fields can be initialized by name at creation. For example:

    S = SeisHdr(cat="NEIC", mag=3.3)

Create a seismic header with S.cat="NEIC" and S.mag=3.3. Unspecified fields are set to system defaults.
"""
type SeisHdr
  id::Int64
  time::DateTime
  lat::Float64
  lon::Float64
  dep::Float64
  mag::Float32
  mag_typ::String
  mag_auth::String
  auth::String
  cat::String
  contrib::String
  contrib_id::Int64
  loc_name::String

  # Very ill-defined behavior seems to follow from the use of keywords .type or .*_type

  SeisHdr(; id=0::Int64,
            time=now()::DateTime,
            lat=0.0::Float64,
            lon=0.0::Float64,
            dep=0.0::Float64,
            mag=(-5.0f0)::Float32,
            mag_typ="No mag"::String,
            mag_auth=""::String,
            auth="None"::String,
            cat="None"::String,
            contrib=""::String,
            contrib_id=0::Int64,
            loc_name="Annywn, beneath the waves"::String) = begin
     return new(id, time, lat, lon, dep, mag, mag_typ, mag_auth, auth,
              cat, contrib, contrib_id, loc_name)
  end
end

"""
    S = SeisEvent()

Create a seismic event consisting of a seismic header object, S.hdr, and a seismic data object, S.data.
"""
type SeisEvent
  hdr::SeisHdr
  data::SeisData
  SeisEvent(; hdr=SeisHdr()::SeisHdr, data=SeisData()::SeisData) = return new(hdr, data)
end

# =============================================================================
# Formatting for output to STDOUT
# hdr
show(io::IO, S::SeisHdr) = (
  println(io, summary(S));
  [println(uppercase(@sprintf("%10s",v)),": ", getfield(S,v)) for v in fieldnames(S)]
  )
show(S::SeisHdr) = show(STDOUT, S)
summary(S::SeisHdr) = string("type ", typeof(S), " with values")

# event
show(io::IO, S::SeisEvent) = (
  println(io, typeof(S), ":");
  println(io, "\n(.hdr)");
  show(S.hdr);
  println(io, "\n(.data)");
  show(S.data);
  )
summary(S::SeisEvent) = string(typeof(S))
