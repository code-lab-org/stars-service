// Copyright (C) 2019 Ryan Linnabary
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

#include <cstdint>
#include <string>
#include <vector>

#include "collaborate/antenna_dipole.h"
#include "collaborate/antenna_helical.h"
#include "collaborate/battery.h"
#include "collaborate/data_logger.h"
#include "collaborate/data_processor_source.h"
#include "collaborate/data_processor_template.h"
#include "collaborate/event_logger.h"
#include "collaborate/modem_uhf_deploy.h"
#include "collaborate/observing_system_alpha.h"
#include "collaborate/platform_orbit.h"
#include "collaborate/scheduler_alpha.h"
#include "collaborate/sensor_cloud_radar.h"
#include "collaborate/sensor_rain_radar.h"
#include "collaborate/simulation_clock.h"
#include "collaborate/solar_panel.h"
#include "collaborate/subsystem_comm.h"
#include "collaborate/subsystem_power.h"
#include "collaborate/subsystem_sensing.h"
#include "collaborate/sun.h"

namespace osse {
namespace collaborate {
void SimpleObservingSystemSimulation() {
    
  // Simulation Parameters
  constexpr uint64_t kNumTicks = 10000;
  constexpr uint64_t kSecondsPerTick = 1;

  // Loggers
  DataLogger data_log("output/data.nc4");
  EventLogger event_log("output/events.txt");
  DataLogger net_log("output/network.nc4");

  // Observing System
  SimulationClock clock(&data_log);
  SchedulerAlpha scheduler(&clock);
  Sun sun(&clock);
  ObservingSystemAlpha system(&sun, &clock, &scheduler, &event_log, &net_log);

  // Satellite Hardware
  %SATELLITE_HARDWARE%

  // Final Setup
  data_log.Simulation(system.nodes().size(), kNumTicks);
  net_log.UnweightedNetwork(system.nodes().size(), kNumTicks);
  event_log.Initialize("info", "info", true);

  // Simulation
  for (uint64_t tick = 0; tick < kNumTicks; ++tick) {
    system.Update();
    clock.Tick(kSecondsPerTick);
  }
  system.Complete();
  clock.Flush();
}
}  // namespace collaborate
}  // namespace osse

int main() {
  osse::collaborate::SimpleObservingSystemSimulation();
  return 0;
}
