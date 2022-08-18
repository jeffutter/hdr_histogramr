use hdrhistogram::{
    serialization::{Deserializer, Serializer, V2DeflateSerializer, V2Serializer},
    Counter, Histogram,
};
use rustler::{resource::ResourceArc, Env, Term};
use std::sync::Mutex;

struct HG<T: Counter>(Mutex<Histogram<T>>);

impl<T> HG<T>
where
    T: Counter,
{
    pub fn new(sigfig: u8) -> Self {
        Self(Mutex::new(Histogram::<T>::new(sigfig).unwrap()))
    }

    pub fn new_with_max(high: u64, sigfig: u8) -> Self {
        Self(Mutex::new(
            Histogram::<T>::new_with_max(high, sigfig).unwrap(),
        ))
    }

    pub fn new_with_bounds(low: u64, high: u64, sigfig: u8) -> Self {
        Self(Mutex::new(
            Histogram::<T>::new_with_bounds(low, high, sigfig).unwrap(),
        ))
    }
}

#[rustler::nif]
fn new(sigfig: u8) -> ResourceArc<HG<u64>> {
    let hg = HG::new(sigfig);
    ResourceArc::new(hg)
}

#[rustler::nif]
fn new_with_max(high: u64, sigfig: u8) -> ResourceArc<HG<u64>> {
    let hg = HG::new_with_max(high, sigfig);
    ResourceArc::new(hg)
}

#[rustler::nif]
fn new_with_bounds(low: u64, high: u64, sigfig: u8) -> ResourceArc<HG<u64>> {
    let hg = HG::new_with_bounds(low, high, sigfig);
    ResourceArc::new(hg)
}

#[rustler::nif]
fn record(hg: ResourceArc<HG<u64>>, v: u64) -> bool {
    let mut hg = hg.0.lock().unwrap();
    hg.record(v).unwrap();
    true
}

#[rustler::nif]
fn record_correct(hg: ResourceArc<HG<u64>>, v: u64, i: u64) -> bool {
    let mut hg = hg.0.lock().unwrap();
    hg.record_correct(v, i).unwrap();
    true
}

#[rustler::nif]
fn add(hg1: ResourceArc<HG<u64>>, hg2: ResourceArc<HG<u64>>) -> bool {
    let mut hg1 = hg1.0.lock().unwrap();
    let hg2 = hg2.0.lock().unwrap();
    hg1.add(&*hg2).unwrap();
    true
}

#[rustler::nif]
fn dump(hg: ResourceArc<HG<u64>>) -> Vec<u8> {
    let hg = hg.0.lock().unwrap();
    let mut ser = V2DeflateSerializer::new();
    let mut vec = Vec::new();
    ser.serialize(&hg, &mut vec).unwrap();

    vec
}

#[rustler::nif]
fn _value_at_quantile(hg: ResourceArc<HG<u64>>, quantile: f64) -> u64 {
    let hg = hg.0.lock().unwrap();
    hg.value_at_quantile(quantile)
}

#[rustler::nif]
fn _value_at_percentile(hg: ResourceArc<HG<u64>>, percentile: f64) -> u64 {
    let hg = hg.0.lock().unwrap();
    hg.value_at_percentile(percentile)
}

#[rustler::nif]
fn len(hg: ResourceArc<HG<u64>>) -> u64 {
    let hg = hg.0.lock().unwrap();
    hg.len()
}

#[rustler::nif]
fn min(hg: ResourceArc<HG<u64>>) -> u64 {
    let hg = hg.0.lock().unwrap();
    hg.min()
}

#[rustler::nif]
fn max(hg: ResourceArc<HG<u64>>) -> u64 {
    let hg = hg.0.lock().unwrap();
    hg.max()
}

#[rustler::nif]
fn mean(hg: ResourceArc<HG<u64>>) -> f64 {
    let hg = hg.0.lock().unwrap();
    hg.mean()
}

#[rustler::nif]
fn to_binary(hg: ResourceArc<HG<u64>>) -> Vec<u8> {
    let hg = hg.0.lock().unwrap();
    let mut ser = V2Serializer::new();
    let mut vec = Vec::new();
    ser.serialize(&hg, &mut vec).unwrap();
    vec
}

#[rustler::nif]
fn from_binary(vec: Vec<u8>) -> ResourceArc<HG<u64>> {
    let hg: Histogram<u64> = Deserializer::new()
        .deserialize(&mut vec.as_slice())
        .unwrap();

    ResourceArc::new(HG(Mutex::new(hg)))
}

fn load(env: Env, _info: Term) -> bool {
    rustler::resource!(HG<u64>, env);
    true
}

rustler::init!(
    "Elixir.HDRHistogramr",
    [
        _value_at_percentile,
        _value_at_quantile,
        add,
        dump,
        from_binary,
        len,
        max,
        mean,
        min,
        new,
        new_with_max,
        new_with_bounds,
        record,
        record_correct,
        to_binary,
    ],
    load = load
);
